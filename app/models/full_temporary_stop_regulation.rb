class FullTemporaryStopRegulation < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :fts_regulation_actions, foreign_key: [:fts_regulation_role, :fts_regulation_id]
  has_many :stopped_fts_regulation_actions, foreign_key: [:stopped_regulation_role, :stopped_regulation_id],
                                            class_name: 'FtsRegulationAction'
  belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_role,
                                                            :explicit_abrogation_regulation_id]
end

# == Schema Information
#
# Table name: full_temporary_stop_regulations
#
#  record_code                         :string(255)
#  subrecord_code                      :string(255)
#  record_sequence_number              :string(255)
#  full_temporary_stop_regulation_role :integer(4)
#  full_temporary_stop_regulation_id   :string(255)
#  published_date                      :date
#  officialjournal_number              :string(255)
#  officialjournal_page                :integer(4)
#  validity_start_date                 :date
#  validity_end_date                   :date
#  effective_enddate                   :date
#  explicit_abrogation_regulation_role :integer(4)
#  explicit_abrogation_regulation_id   :string(255)
#  replacement_indicator               :integer(4)
#  information_text                    :text
#  approved_flag                       :boolean(1)
#  created_at                          :datetime
#  updated_at                          :datetime
#

