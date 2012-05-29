class Chapter
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :code,         type: String
  field :description,  type: String

  # indexes
  index({ code: 1 }, { unique: true, background: true })

  # associations
  belongs_to :nomenclature, index: true
  belongs_to :section, index: true
  has_many :headings
end
