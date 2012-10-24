class MeasureTypeSeries < Sequel::Model
  set_primary_key  :measure_type_series_id

  ######### Conformance validations 140
  def validate
    super
    # MTS1
    validates_unique([:measure_type_series_id, :measure_type_combination])
    # TODO: MTS2
    # The measure type series cannot be deleted if it is associated with a measure type.
    # MTS3
    validates_start_date
  end
end


