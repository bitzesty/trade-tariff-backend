class RegulationGroup < Sequel::Model
  set_primary_key  :regulation_group_id

  one_to_many :base_regulations

  ######### Conformance validations 150
  validates do
    # RG1
    uniqueness_of :regulation_group_id
    # RG3
    validity_dates
  end

  def before_destroy
    # RG2
    return false if base_regulations.any?

    super
  end
end


