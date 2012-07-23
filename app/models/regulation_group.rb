class RegulationGroup < Sequel::Model
  set_primary_key  :regulation_group_id

  # has_many :base_regulations
  # has_one  :regulation_group_description, foreign_key: :regulation_group_id
end


