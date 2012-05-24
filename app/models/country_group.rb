class CountryGroup
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        type: String
  field :description, type: String

  has_and_belongs_to_many :countries
  has_many :measures, as: :region

  def to_s
    code
  end
end

