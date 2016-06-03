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

  attr_accessor :t
  attr_reader :result, :as_of

  validates :t, presence: true
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

  def t=(term)
    # if search term has no letters extract the digits
    # and perform search with just the digits
    @t = if term =~ /^(?!.*[A-Za-z]+).*$/
           term.scan(/\d+/).join
         else
           # ignore [ and ] characters to avoid range searches
           term.to_s.gsub(/(\[|\])/,'')
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
    @result = ExactSearch.new(t, as_of).search!.presence ||
              FuzzySearch.new(t, as_of).search!.presence ||
              NullSearch.new(t, as_of)
  end
end
