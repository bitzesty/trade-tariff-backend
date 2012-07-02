class FootnoteAssociationMeasure < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :footnote
  belongs_to :footnote_type
end
