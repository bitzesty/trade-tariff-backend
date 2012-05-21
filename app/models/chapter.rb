class Chapter
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :code,         type: String
  field :description,  type: String

  # associations
  belongs_to :nomenclature
  belongs_to :section
  has_many :headings
end
