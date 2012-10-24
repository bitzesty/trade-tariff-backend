class RegulationGroup < Sequel::Model
  set_primary_key  :regulation_group_id

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


