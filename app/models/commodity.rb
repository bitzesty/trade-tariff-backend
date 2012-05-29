class Commodity
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tire::Model::Search
  include Tire::Model::Callbacks

  # fields
  field :code,         type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: String
  field :synonyms,      type: String

  # indexes
  index({ code: 1 }, { unique: true, background: true })

  # associations
  has_many :measures, as: :measurable
  belongs_to :nomenclature, index: true
  belongs_to :heading, index: true

  # tire configuration
  tire do
    mapping do
      indexes :id,                      index: :not_analyzed
      indexes :description,             analyzer: 'snowball'
      indexes :code,                    analyzer: 'snowball'
      indexes :synonyms,                analyzer: 'snowball', boost: 10

      indexes :heading do
        indexes :id,                      index: :not_analyzed
        indexes :description,             analyzer: 'snowball'
        indexes :code,                    analyzer: 'snowball'
      end

      indexes :chapter do
        indexes :id,                      index: :not_analyzed
        indexes :description,             analyzer: 'snowball'
        indexes :code,                    analyzer: 'snowball'
      end

      indexes :section do
        indexes :id,                      index: :not_analyzed
        indexes :title,                   analyzer: 'snowball'
        indexes :numeral,                 index: :not_analyzed
      end
    end
  end

  # kaminari
  paginates_per 25

  def to_indexed_json
    chapter = heading.chapter
    section = chapter.section

    {
      code: code,
      description: description,
      heading: {
        id: heading.id,
        code: heading.code,
        description: heading.description
      },
      chapter: {
        id: chapter.id,
        code: chapter.code,
        description: chapter.description
      },
      section: {
        id: section.id,
        title: section.title,
        numeral: section.numeral
      }
    }.to_json
  end
end
