class ProrogationRegulationAction < Sequel::Model
  set_primary_key  :prorogation_regulation_id, :prorogation_regulation_role,
                   :prorogated_regulation_id, :prorogated_regulation_role

  # belongs_to :prorogation_regulation, foreign_key: [:prorogation_regulation_id,
  #                                                   :prorogation_regulation_role]
  # belongs_to :prorogated_regulation, foreign_key: [:prorogated_regulation_id,
  #                                                  :prorogated_regulation_role],
  #                                    class_name: 'BaseRegulation'
end

# == Schema Information
#
# Table name: prorogation_regulation_actions
#
#  record_code                 :string(255)
#  subrecord_code              :string(255)
#  record_sequence_number      :string(255)
#  prorogation_regulation_role :integer(4)
#  prorogation_regulation_id   :string(255)
#  prorogated_regulation_role  :integer(4)
#  prorogated_regulation_id    :string(255)
#  prorogated_date             :date
#  created_at                  :datetime
#  updated_at                  :datetime
#

