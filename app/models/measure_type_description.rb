class MeasureTypeDescription < Sequel::Model
  set_primary_key :measure_type_id

  def to_s
    description
  end
end


