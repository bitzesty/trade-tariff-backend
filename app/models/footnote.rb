class Footnote < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :footnote_type, primary_key: :footnote_type_id
  has_one  :footnote_description
  has_many :footnote_description_period
end
