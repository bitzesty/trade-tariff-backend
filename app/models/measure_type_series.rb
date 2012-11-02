class MeasureTypeSeries < Sequel::Model
  set_primary_key  :measure_type_series_id

  one_to_many :measure_types

  ######### Conformance validations 140
  validates do
    # MTS1
    uniqueness_of [:measure_type_series_id, :measure_type_combination]
    # MTS3
    validity_dates
  end

  def before_destroy
    # MTS2
    return false if measure_types.any?

    super
  end
end


