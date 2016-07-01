module Chief
  class MeasureTypeCond < Sequel::Model(:chief_measure_type_cond)
    set_primary_key [:measure_group_code, :measure_type]
  end
end
