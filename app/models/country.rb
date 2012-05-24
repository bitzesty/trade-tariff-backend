class Country
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String
  field :iso_code, type: String

  has_and_belongs_to_many :country_groups
  has_many :measures, as: :region
end
