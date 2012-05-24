class CountryGroup
  include Mongoid::Document

  field :code,        type: String
  field :description, type: String

  has_and_belongs_to_many :countries

  def to_s
    code
  end
end
