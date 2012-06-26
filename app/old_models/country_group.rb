class CountryGroup
  # include Mongoid::Document
  # include Mongoid::Timestamps

  # field :area_id,     type: String
  # field :sigl,        type: String
  # field :description, type: String

  # has_and_belongs_to_many :countries
  # has_many :measures, as: :region

  # alias :name :description

  # def class_name
  #   self.class.name
  # end

  # def to_s
  #   description
  # end
end

