class RegulationGroup < Sequel::Model
  set_primary_key  :regulation_group_id

  # has_many :base_regulations
  # has_one  :regulation_group_description, foreign_key: :regulation_group_id

  ######### Conformance validations 150
  def validate
    super
    # RG1
    validates_unique(:regulation_group_id)
    # TODO: RG2
    # RG3
    validates_start_date
  end
end


