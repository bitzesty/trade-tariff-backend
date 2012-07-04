class RegulationGroup < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  has_many :base_regulations
  has_one  :description, class_name: 'RegulationGroupDescription',
                         foreign_key: :regulation_group_id
end
