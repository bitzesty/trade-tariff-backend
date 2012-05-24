class Measure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :origin,           type: String # EU/UK
  field :measure_type,     type: String
  field :restriction,      type: Boolean # is it a restriction or regular tariff
  field :duty_rate,        type: String
  field :legal_act_url

  has_many :excluded_countries, class_name: 'Country'
  has_and_belongs_to_many :footnotes
  has_and_belongs_to_many :conditions
  has_and_belongs_to_many :additional_codes
  belongs_to :postable, polymorphic: true
  belongs_to :region, polymorphic: true
end

