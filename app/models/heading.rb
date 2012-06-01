class Heading
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :code,         type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: String
  field :short_code,   type: String

  # indexes
  index({ short_code: 1 }, { unique: true, background: true })

  # associations
  belongs_to :nomenclature, index: true
  belongs_to :chapter, index: true
  has_many :commodities
  has_many :measures, as: :measurable

  # callbacks
  before_save :assign_short_code

  def chapter_section
    chapter.section
  end

  def has_measures?
    measures.present?
  end
  alias :has_measures :has_measures?

  def to_param
    short_code
  end

  def to_s
    "<Heading: #{code}>"
  end

  private

  def assign_short_code
    self.short_code = code.first(4)
  end
end
