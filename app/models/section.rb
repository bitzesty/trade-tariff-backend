class Section
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :title,    type: String
  field :numeral,  type: String
  field :position, type: Integer

  # associations
  belongs_to :nomenclature, index: true
  has_many :chapters
end
