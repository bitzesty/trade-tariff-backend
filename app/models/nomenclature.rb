class Nomenclature
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :as_of_date, type: Date

  # associations
  has_many :sections
  has_many :chapters
  has_many :headings
  has_many :commodities
end
