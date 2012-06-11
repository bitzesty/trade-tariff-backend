class BaseCommodity
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tire::Model::Search

  field :code,         type: String
  field :short_code,   type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: Integer
  field :synonyms,     type: String
  field :uk_vat_rate_cache,         type: String
  field :third_country_duty_cache,  type: String

  # indexes
  index({ code: 1 }, { background: true })

  # relations
  belongs_to :nomenclature, index: true
  has_many :measures, as: :measurable

  # validations
  validates :code, presence: true
  validates :description, presence: true
  validates :nomenclature_id, presence: true

  # callbacks
  after_save :index_with_tire
  after_destroy :index_with_tire
  before_validation :assign_short_code

  # tire configuration
  tire do
    mapping do
      indexes :id,                      index: :not_analyzed
      indexes :description,             analyzer: 'snowball', boost: 20
      indexes :code,                    analyzer: 'simple'
      indexes :short_code,              index: :not_analyzed
      indexes :synonyms,                analyzer: 'snowball', boost: 20
      indexes :parents,                 type: 'string', analyzer: 'snowball', boost: 10

      indexes :heading do
        indexes :id,                      index: :not_analyzed
        indexes :description,             analyzer: 'snowball'
        indexes :code,                    analyzer: 'simple'
        indexes :short_code,              index: :not_analyzed
      end

      indexes :chapter do
        indexes :id,                      index: :not_analyzed
        indexes :description,             analyzer: 'snowball'
        indexes :code,                    analyzer: 'simple'
        indexes :short_code,              index: :not_analyzed
      end

      indexes :section do
        indexes :id,                      index: :not_analyzed
        indexes :title,                   analyzer: 'snowball'
        indexes :numeral,                 index: :not_analyzed
        indexes :position,                index: :not_analyzed
      end
    end
  end

  def to_indexed_json
    {
      code: code,
      short_code: short_code,
      description: description,
      short_code: short_code,
      uk_vat_rate: uk_vat_rate,
      third_country_duty: third_country_duty,
      chapter: {
        id: chapter.id,
        code: chapter.code,
        description: chapter.description,
        short_code: chapter.short_code
      },
      section: {
        id: section.id,
        title: section.title,
        numeral: section.numeral,
        position: section.position
      }
    }
  end

  private

  def index_with_tire
    self.tire.update_index
  end
end
