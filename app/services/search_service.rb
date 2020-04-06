# SearchService is responsible for issuing search queries
# it tries to do ExactSearch first in case search term consists
# of numerical values. We can guess if that was a Section, Chapter,
# Heading ir Commodity code and redirect the user straight there.
#
# Otherwise it issues FuzzySearch that searches for results inside
# green pages (synonyms) index as well as the main goods nomenclature
# index and persents those results in single response. Fuzzy searching
# functionality is split into ReferenceMatch and GoodsNomenclatureMatch
# classes respectively.

class SearchService
  autoload :BaseSearch,  'search_service/base_search'
  autoload :ExactSearch, 'search_service/exact_search'
  autoload :FuzzySearch, 'search_service/fuzzy_search'
  autoload :NullSearch,  'search_service/null_search'

  INDEX_SIZE_MAX = 10000 # ElasticSearch does default pagination for 10 entries
                         # per page. We do not do pagination when displaying
                         # results so have a constant much bigger than possible
                         # index size for size value.

  include ActiveModel::Validations
  include ActiveModel::Conversion

  class EmptyQuery < StandardError
  end

  attr_accessor :q
  attr_reader :result, :as_of, :data_serializer, :error_serializer

  validates :q, presence: true
  validates :as_of, presence: true

  delegate :serializable_hash, to: :result

  def initialize(data_serializer, error_serializer, attributes = {})
    if attributes.present?
      attributes.each do |name, value|
        if self.respond_to?(:"#{name}=")
          send(:"#{name}=", value)
        end
      end
    end
    @data_serializer = data_serializer
    @error_serializer = error_serializer
  end

  def as_of=(date)
    @as_of = begin
               Date.parse(date)
             rescue StandardError
               Date.current
             end
  end

  def q=(term)
    # if search term has no letters extract the digits
    # and perform search with just the digits
    @q = if m = /\A(cas\s*)?(\d+-\d+-\d)\z/i.match(term)
           # handle CAS search, with optional leading string "cas "
           m[2]
         elsif /^(?!.*[A-Za-z]+).*$/.match?(term)
           term.scan(/\d+/).join
         else
           # ignore [ and ] characters to avoid range searches
           term.to_s.gsub(/(\[|\])/, '')
         end
  end

  def exact_match?
    result.is_a?(ExactSearch)
  end

  def to_json(_config = {})
    if valid?
      perform

      data_serializer.perform(result)
    else
      error_serializer.serialized_errors(errors)
    end
  end

  def persisted?
    false
  end

private

  def perform
    @result = ExactSearch.new(q, as_of).search!.presence ||
      FuzzySearch.new(q, as_of).search!.presence ||
      NullSearch.new(q, as_of)
  end
end
