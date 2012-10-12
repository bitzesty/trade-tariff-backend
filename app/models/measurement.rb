class Measurement < Sequel::Model
  set_primary_key  :measurement_unit_code, :measurement_unit_qualifier_code


  ######### Conformance validations 220
  def validate
    super
    # MENT1
    validates_unique([:measurement_unit_code, :measurement_unit_qualifier_code])
    # MENT2
    # MENT3
    # MENT4
    # MENT5
    # MENT6
    validates_start_date
  end
end


