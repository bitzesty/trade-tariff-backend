class ExplicitAbrogationRegulation < ActiveRecord::Base
  self.primary_keys =  :explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role

  has_many :modification_regulations, foreign_key: [:explicit_abrogation_regulation_role,
                                                    :explicit_abrogation_regulation_id]
  has_many :full_temporary_stop_regulations, foreign_key: [:explicit_abrogation_regulation_role,
                                                           :explicit_abrogation_regulation_id]
  has_many :base_regulations, foreign_key: [:explicit_abrogation_regulation_role,
                                            :explicit_abrogation_regulation_id]
end

# == Schema Information
#
# Table name: explicit_abrogation_regulations
#
#  record_code                         :string(255)
#  subrecord_code                      :string(255)
#  record_sequence_number              :string(255)
#  explicit_abrogation_regulation_role :integer(4)
#  explicit_abrogation_regulation_id   :string(255)
#  published_date                      :date
#  officialjournal_number              :string(255)
#  officialjournal_page                :integer(4)
#  replacement_indicator               :integer(4)
#  abrogation_date                     :date
#  information_text                    :text
#  approved_flag                       :boolean(1)
#  created_at                          :datetime
#  updated_at                          :datetime
#

