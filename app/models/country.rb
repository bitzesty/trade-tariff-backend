class Country
  include Mongoid::Document

  field :name,     type: String
  field :iso_code, type: String

  has_and_belongs_to_many :country_groups
end
