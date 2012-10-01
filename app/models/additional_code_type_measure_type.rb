class AdditionalCodeTypeMeasureType < Sequel::Model
  set_primary_key [:measure_type_id, :additional_code_type_id]

  many_to_one :measure_type
  many_to_one :additional_code_type

  ######### Conformance validations 240
  def validate
    super
    # AMT1
    # AMT2
    validates_presence([:measure_type_id, :additional_code_type_id])
    # AMT3
    validates_unique([:measure_type_id, :additional_code_type_id])
    # TODO: AMT4
    # AMT5
    validates_start_date
    # TODO: AMT7
  end

end


