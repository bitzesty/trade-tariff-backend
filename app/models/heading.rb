class Heading
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :code,         type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: String
  field :short_code,   type: String
  field :uk_vat_rate_cache,         type: String
  field :third_country_duty_cache,  type: String

  # indexes
  index({ short_code: 1 }, { unique: true, background: true })

  # associations
  belongs_to :nomenclature, index: true
  belongs_to :chapter, index: true
  has_many :commodities
  has_many :measures, as: :measurable

  # callbacks
  before_save :assign_short_code

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

  private

  def assign_short_code
    self.short_code = code.first(4)
  end
end
