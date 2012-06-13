class Heading < BaseCommodity
  # indexes
  index({ short_code: 1 }, { unique: true, background: true })

  # tire
  # same index as commodities
  index_name BaseCommodity::INDEX_NAME

  # associations
  belongs_to :chapter, index: true
  has_many :commodities

  # validations
  validates :chapter_id, presence: true
  validates :short_code, presence: true, length: { is: 4 }

  def has_measures?
    measures.present?
  end
  alias :has_measures :has_measures?

  def declarative
    commodities.none?
  end

  def to_param
    short_code
  end

  def section
    chapter.section
  end

  def to_indexed_json
    super.to_json
  end

  def to_s
    "<Heading: #{code}>"
  end

    def assign_short_code
    self.short_code = code.first(4)
  end
end
