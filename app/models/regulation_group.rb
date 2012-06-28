class RegulationGroup < ActiveRecord::Base
  self.primary_key = :regulation_group_id

  has_many :base_regulations
  has_one  :description, class_name: 'RegulationGroupDescription',
                         foreign_key: :regulation_group_id
end
