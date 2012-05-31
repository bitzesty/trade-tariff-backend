class Commodity
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tire::Model::Search
  include Tire::Model::Callbacks

  # fields
  field :code,         type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: Integer
  field :synonyms,     type: String
  field :short_code,   type: String

  # indexes
  index({ code: 1 }, { background: true })

  # associations
  has_many :measures, as: :measurable
  has_many :children, class_name: 'Commodity',
                      inverse_of: :parent

  belongs_to :nomenclature, index: true
  belongs_to :heading, index: true
  belongs_to :parent, class_name: 'Commodity',
                      inverse_of: :children

  # callbacks
  before_save :assign_short_code

  # tire configuration
  tire do
    mapping do
      indexes :id,                      index: :not_analyzed
      indexes :description,             analyzer: 'snowball'
      indexes :code,                    analyzer: 'simple'
      indexes :short_code,              index: :not_analyzed
      indexes :synonyms,                analyzer: 'snowball', boost: 10

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

  # kaminari
  paginates_per 25

  def uk_vat_rate
    measures.uk_vat.first.duty_rates
  end

  def third_country_duty
    measures.third_country.first.duty_rates
  end

  def to_indexed_json
    chapter = heading.chapter
    section = chapter.section

    {
      code: code,
      short_code: short_code,
      description: description,
      short_code: short_code,
      uk_vat_rate: uk_vat_rate,
      third_country_duty: third_country_duty,
      heading: {
        id: heading.id,
        code: heading.code,
        description: heading.description,
        short_code: heading.short_code
      },
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
    }.to_json
  end

  def to_param
    code
  end

  private

  def assign_short_code
    self.short_code = code.first(10)
  end
end
