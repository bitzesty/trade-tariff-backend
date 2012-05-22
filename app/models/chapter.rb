class Chapter
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :code,         type: String
  field :description,  type: String

  # indexes
  index :code, unique: true

  # associations
  belongs_to :nomenclature, index: true
  belongs_to :section, index: true
  has_many :headings
end
