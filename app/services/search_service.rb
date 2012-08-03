class SearchService
  INDEX_SIZE_MAX = 1000000 # ElasticSearch does default pagination for 10 entries
                           # per page. We do not do pagination when displaying
                           # results so have a constant much bigger than possible
                           # index size for size value.

  include ActiveModel::Validations
  include ActiveModel::Conversion

  class EmptyQuery < StandardError; end

  module ExactSearch
    def self.search(query_string)
      case query_string
      when /^[0-9]{1,3}$/
        Chapter.actual.by_code(query_string).first
      when /^[0-9]{4,9}$/
        Heading.actual.by_code(query_string).first
      when /^[0-9]{10}$/
        Commodity.actual.by_code(query_string).declarable.first.presence ||
        Heading.actual.by_declarable_code(query_string).declarable.first.presence
      when /^[0-9]{11,12}$/
        Commodity.actual.by_code(query_string).declarable.first
      end
    end
  end

  module FuzzySearch
    def self.search(query_string, date)
      {
        sections: results_for('sections', query_string, date, query_string: { fields: ["title"] }),
        chapters: results_for('chapters', query_string, date),
        headings: results_for('headings', query_string, date),
        commodities: results_for('commodities', query_string, date)
      }
    end

    def self.results_for(index, query_string, date, query_opts = {})
      Tire.search(index, { query: {
                             query_string: {
                               query: query_string,
                               fields: ["description"]
                             }.merge(query_opts)
                           },
                           filter: {
                             or: [
                               {
                                 range: {
                                   validity_start_date: { lte: date },
                                   validity_end_date:   { gte: date }
                                 }
                               },
                               {
                                 and: [
                                  { range: { validity_start_date: { lte: date } } },
                                  { missing: { field: "validity_end_date" } }
                                ]
                               }
                             ]
                           },
                           size: INDEX_SIZE_MAX
                         }
                 ).results
    end
  end

  attr_accessor :q
  attr_reader :results, :as_of

  validates :q, presence: true
  validates :as_of, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      if self.respond_to?(:"#{name}=")
        send(:"#{name}=", value)
      end
    end if attributes.present?
  end

  def as_of=(date)
    @as_of = begin
               Date.parse(date)
             rescue
               Date.today
             end
  end

  def exact_match
    @results.present? && @results.is_a?(GoodsNomenclature)
  end
  alias :exact_match? :exact_match

  def serializable_hash
    if exact_match?
      {
        type: "exact_match",
        entry: {
          endpoint: @results.class.name.parameterize("_").pluralize,
          id: @results.to_param
        }
      }
    else
      {
        type: "fuzzy_match",
        entries: @results
      }
    end
  end

  def to_json(config = {})
    if valid?
      perform

      serializable_hash.to_json
    else
      errors.to_json
    end
  end

  def persisted?
    false
  end

  private

  def perform
    @results = ExactSearch.search(q).presence || FuzzySearch.search(q, as_of)

    # sm = SearchMetric.where(q: q, q_on: Date.today).first
    # if sm
    #   sm.inc(:count, 1)
    # else
    #   SearchMetric.create(q: q, q_on: Date.today, results: search.total_entries)
    # end
  end

end
