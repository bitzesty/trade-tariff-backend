class Measure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :origin,           type: String # EU/UK
  field :measure_type,     type: String
  field :duty_rates ,      type: String

  has_and_belongs_to_many :excluded_countries, inverse_of: :measure_exclusions,
                                               class_name: 'Country'
  has_and_belongs_to_many :footnotes
  has_and_belongs_to_many :additional_codes
  belongs_to :legal_act
  belongs_to :measurable, polymorphic: true
  belongs_to :region, polymorphic: true

  embeds_many :conditions
end

