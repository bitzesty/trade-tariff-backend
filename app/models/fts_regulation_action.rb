class FtsRegulationAction < ActiveRecord::Base
  self.primary_keys =  :fts_regulation_id, :fts_regulation_role,
                   :stopped_regulation_id, :stopped_regulation_role

  belongs_to :fts_regulation, foreign_key: [:fts_regulation_id, :fts_regulation_role],
                              class_name: 'FullTemporaryStopRegulation'
  belongs_to :stopped_fts_regulation, foreign_key: [:stopped_regulation_id, :stopped_regulation_role],
                                      class_name: 'FullTemporaryStopRegulation'
  belongs_to :fts_regulation_role_type, foreign_key: :fts_regulation_role,
                                        class_name: 'RegulationRoleType'
  belongs_to :stopped_regulation_role_type, foreign_key: :stopped_regulation_role,
                                        class_name: 'RegulationRoleType'
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

