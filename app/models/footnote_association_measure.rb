class FootnoteAssociationMeasure < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :footnote
  belongs_to :footnote_type
end

# == Schema Information
#
# Table name: footnote_association_measures
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  measure_sid            :string(255)
#  footnote_type_id       :string(255)
#  footnote_id            :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

