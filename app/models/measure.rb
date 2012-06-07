class Measure
  include Mongoid::Document
  include Mongoid::Timestamps

  UK_VAT_STRINGS = ["VAT standard rate", "VAT zero rate"]
  DUTY_STRINGS = ["Third country duty", "Non preferential duty under end use"]

  field :export,           type: Boolean
  field :origin,           type: String # EU/UK
  field :measure_type,     type: String
  field :duty_rates,       type: String

  has_and_belongs_to_many :excluded_countries, inverse_of: :measure_exclusions,
                                               class_name: 'Country', index: true
  has_and_belongs_to_many :footnotes, index: true
  has_and_belongs_to_many :additional_codes, index: true
  belongs_to :legal_act, index: true
  belongs_to :measurable, polymorphic: true, index: true
  belongs_to :region, polymorphic: true, index: true

  embeds_many :conditions

  scope :for_import, where(export: false)
  scope :for_export, where(export: true)

  scope :uk_vat, where(:measure_type.in => UK_VAT_STRINGS)
  scope :third_country, where(:measure_type.in => DUTY_STRINGS)
  scope :ergo_omnes, where(:region_id => nil)
  scope :specific, where(:region_id.ne => nil)

  # Applicable for all countries
  def ergo_omnes?
    region.blank?
  end

  def to_s
    "<Measure: #{measure_type}>"
  end
end

