class ProrogationRegulationAction < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
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

