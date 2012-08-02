class SearchService
  INDEX_SIZE_MAX = 100000

  include ActiveModel::Validations
  include ActiveModel::Conversion

  class EmptyQuery < StandardError; end

  module ExactSearch
    def self.search(query_string)
      case query_string
      when /^[0-9]{1,3}$/
        Chapter.by_code(query_string).first
      when /^[0-9]{4,9}$/
        Heading.by_code(query_string).first
      when /^[0-9]{10}$/
        Commodity.by_code(query_string).declarable.first.presence ||
        Heading.by_declarable_code(query_string).declarable.first.presence
      when /^[0-9]{11,12}$/
        Commodity.by_code(query_string).declarable.first
      end
    end
  end

  module FuzzySearch
    def self.search(query_string)
      {
        sections: results_for('sections', query_string),
        chapters: results_for('chapters', query_string),
        headings: results_for('headings', query_string),
        commodities: results_for('commodities', query_string)
      }
    end

    def self.results_for(index, query_string, opts = {})
      Tire.search(index, { query: {
                             query_string: {
                               query: query_string,
                               fields: ["description"]
                             }
                           },
                           size: INDEX_SIZE_MAX
                         }.deep_merge(opts)
                 ).results
    end
  end

  attr_accessor :q, :as_of
  attr_reader :results

  def initialize(attributes = {})
    attributes.each do |name, value|
      if self.respond_to?(:"#{name}=")
        send(:"#{name}=", value)
      end
    end if attributes.present?

    raise EmptyQuery if q.blank?
  end

  def exact_match
    @results.present? && @results.is_a?(GoodsNomenclature)
  end
  alias :exact_match? :exact_match

  def perform!
    @results = ExactSearch.search(q).presence || FuzzySearch.search(q)

    # sm = SearchMetric.where(q: q, q_on: Date.today).first
    # if sm
    #   sm.inc(:count, 1)
    # else
    #   SearchMetric.create(q: q, q_on: Date.today, results: search.total_entries)
    # end
    self
  end

  def to_json(config = {})
    if exact_match?
      {
        type: "exact_match",
        entry: {
          endpoint: @results.class.name.parameterize("_").pluralize,
          id: @results.to_param
        }
      }.to_json
    else
      {
        type: "fuzzy_match",
        entries: @results
      }.to_json
    end
  end

  def persisted?
    false
  end
end
