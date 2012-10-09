class SearchService
  INDEX_SIZE_MAX = 1000000 # ElasticSearch does default pagination for 10 entries
                           # per page. We do not do pagination when displaying
                           # results so have a constant much bigger than possible
                           # index size for size value.

  include ActiveModel::Validations
  include ActiveModel::Conversion

  class EmptyQuery < StandardError; end

  class BaseSearch
    attr_reader :query_string, :results, :date

    def initialize(query_string, date)
      @query_string = query_string.squish.downcase
      @date = date
    end

    def present?
      @results.present?
    end
  end

  class ExactSearch < BaseSearch
    def search!
      @results = case query_string
                when /^[0-9]{1,3}$/
                  Chapter.actual.by_code(query_string).first
                when /^[0-9]{4,9}$/
                  Heading.actual.by_code(query_string).first
                when /^[0-9]{10}$/
                  Commodity.actual.by_code(query_string).declarable.first.presence ||
                  Heading.actual.by_declarable_code(query_string).declarable.first.presence
                when /^\d{2}\s{1}\d{2}\s{1}\d{2}\s{1}\d{2}\s{1}\d{2}$/ # matches commodity codes in format of ## ## ## ## ##
                  Commodity.actual.by_code(query_string.gsub(/\s+/, '')).declarable.first.presence ||
                  Heading.actual.by_declarable_code(query_string.gsub(/\s+/, '')).declarable.first.presence
                when /^[0-9]{11,12}$/
                  Commodity.actual.by_code(query_string).declarable.first
                end
      self
    end

    def serializable_hash
      {
        type: "exact_match",
        entry: {
          endpoint: results.class.name.parameterize("_").pluralize,
          id: results.to_param
        }
      }
    end
  end

  class FuzzySearch < BaseSearch
    BLANK_RESULT = {
      goods_nomenclature_match: {
        sections: [], chapters: [], headings: [], commodities: []
      },
      reference_match: {
        sections: [], chapters: [], headings: []
      }
    }

    def search!
      begin
        @results = { goods_nomenclature_match: search_results_for(query_string, date),
                     reference_match: reference_results_for(query_string) }
      rescue Tire::Search::SearchRequestFailed
        # rescue from malformed queries, return empty resultset in that case
        BLANK_RESULT
      end

      self
    end

    def serializable_hash
      {
        type: "fuzzy_match",
      }.merge(results)
    end

    private

    def search_results_for(query_string, date)
      {
        sections: results_for('sections', query_string, date, query_string: { fields: ["title"] }),
        chapters: results_for('chapters', query_string, date),
        headings: results_for('headings', query_string, date),
        commodities: results_for('commodities', query_string, date)
      }
    end

    def reference_results_for(query_string)
      {
        sections: reference_search(query_string).select{|r| r.reference['class'] == 'Section' },
        chapters: reference_search(query_string).select{|r| r.reference['class'] == 'Chapter' },
        headings: reference_search(query_string).select{|r| r.reference['class'] == 'Heading' },
        commodities: []
      }
    end

    def reference_search(query_string)
      @reference_results ||= Tire.search('search_references', { query: {
                                               term: {
                                                 title: query_string
                                               }
                                             },
                                             size: INDEX_SIZE_MAX
                                           }
                                        ).results
    end

    def results_for(index, query_string, date, query_opts = {})
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
  attr_reader :result, :as_of

  validates :q, presence: true
  validates :as_of, presence: true

  delegate :serializable_hash, to: :result

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

  def exact_match?
    result.is_a?(ExactSearch)
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
    @result = ExactSearch.new(q, as_of).search!.presence ||
              FuzzySearch.new(q, as_of).search!.presence
  end
end
