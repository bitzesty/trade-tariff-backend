class RegulationRoleType < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :regulation_role_type_id,
                        class_name: 'RegulationRoleTypeDescription'
end

# == Schema Information
#
# Table name: regulation_role_types
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  regulation_role_type_id :string(255)
#  validity_start_date     :date
#  validity_end_date       :date
#  created_at              :datetime
#  updated_at              :datetime
#

