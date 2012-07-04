class FtsRegulationAction < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :fts_regulation, foreign_key: [:fts_regulation_role, :fts_regulation_id],
                              class_name: 'FullTemporaryStopRegulation'
  belongs_to :stopped_fts_regulation, foreign_key: [:stopped_regulation_role, :stopped_regulation_id],
                                      class_name: 'FullTemporaryStopRegulation'
end

# == Schema Information
#
# Table name: fts_regulation_actions
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  fts_regulation_role     :integer(4)
#  fts_regulation_id       :string(255)
#  stopped_regulation_role :integer(4)
#  stopped_regulation_id   :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

