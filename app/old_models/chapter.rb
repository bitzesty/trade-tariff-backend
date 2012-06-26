class Chapter
  # include Mongoid::Document
  # include Mongoid::Timestamps

  # # fields
  # field :code,         type: String
  # field :description,  type: String
  # field :short_code,   type: String

  # # indexes
  # index({ short_code: 1 }, { unique: true, background: true })

  # # associations
  # belongs_to :nomenclature, index: true
  # belongs_to :section, index: true
  # has_many :headings

  # # callbacks
  # before_validation :assign_short_code

  # # validations
  # validates :short_code, presence: true, length: { is: 2 }

  # def to_param
  #   short_code
  # end

  # private

  # def assign_short_code
  #   self.short_code = code.first(2)
  # end
end
