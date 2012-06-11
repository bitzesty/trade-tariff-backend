class Heading < BaseCommodity
  # fields
  field :uk_vat_rate_cache,         type: String
  field :third_country_duty_cache,  type: String

  # indexes
  index({ short_code: 1 }, { unique: true, background: true })

  # tire
  # same index as commodities
  index_name "#{Rails.env}-commodities"

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

  def has_commodities
    commodities.any?
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

  def populate_rates
    if has_measures?
      self.update_attribute(:uk_vat_rate_cache, uk_vat_rate)
      self.update_attribute(:third_country_duty_cache, third_country_duty)
    end
  end

  def uk_vat_rate
    measures.uk_vat.first.duty_rates if measures.uk_vat.any?
  end

  def third_country_duty
    measures.third_country.first.duty_rates if measures.third_country.any?
  end

  def assign_short_code
    self.short_code = code.first(4)
  end
end
