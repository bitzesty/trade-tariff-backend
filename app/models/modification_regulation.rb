require 'sequel/plugins/time_machine'

class ModificationRegulation < Sequel::Model
  plugin :time_machine, period_end_column: :effective_end_date

  set_primary_key [:modification_regulation_id, :modification_regulation_role]

#   belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_id,
#                                                             :explicit_abrogation_regulation_role],
#                                               class_name: 'BaseRegulation'
#   belongs_to :complete_abrogation_regulation, foreign_key: [:complete_abrogation_regulation_id,
#                                                             :complete_abrogation_regulation_role],
#                                               class_name: 'BaseRegulation'
#   belongs_to :base_regulation, foreign_key: [:base_regulation_id,
#                                              :base_regulation_role]
#   belongs_to :modification_regulation_role_type, foreign_key: :modification_regulation_role,
#                                                  class_name: 'RegulationRoleType'

  # scope :effective_on, ->(date) { where{(validity_start_date.lte date) &
  #                                   ((effective_end_date.gte date) |
  #                                    (effective_end_date.eq nil)
  #                                   )}
  #                               }
end

# == Schema Information
#
# Table name: modification_regulations
#
#  record_code                         :string(255)
#  subrecord_code                      :string(255)
#  record_sequence_number              :string(255)
#  modification_regulation_role        :integer(4)
#  modification_regulation_id          :string(255)
#  validity_start_date                 :date
#  validity_end_date                   :date
#  published_date                      :date
#  officialjournal_number              :string(255)
#  officialjournal_page                :integer(4)
#  base_regulation_role                :integer(4)
#  base_regulation_id                  :string(255)
#  replacement_indicator               :integer(4)
#  stopped_flag                        :boolean(1)
#  information_text                    :text
#  approved_flag                       :boolean(1)
#  explicit_abrogation_regulation_role :integer(4)
#  explicit_abrogation_regulation_id   :string(255)
#  effective_end_date                  :date
#  complete_abrogation_regulation_role :integer(4)
#  complete_abrogation_regulation_id   :string(255)
#  created_at                          :datetime
#  updated_at                          :datetime
#

