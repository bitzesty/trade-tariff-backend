class Heading
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :code,         type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: String

  # associations
  belongs_to :nomenclature
  belongs_to :chapter
  has_many :commodities
end
