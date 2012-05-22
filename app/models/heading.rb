class Heading
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :code,         type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: String

  # indexes
  index :code, unique: true

  # associations
  belongs_to :nomenclature, index: true
  belongs_to :chapter, index: true
  has_many :commodities
end
