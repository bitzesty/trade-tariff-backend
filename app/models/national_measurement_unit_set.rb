class NationalMeasurementUnitSet < Sequel::Model
  plugin :time_machine

  set_dataset db[:chief_comm].
              select(Sequel.as(:tbl91__tbl_code, :second_quantity_code)).
              select_more(Sequel.as(:tbl92__tbl_code, :third_quantity_code)).
              select_more(Sequel.as(:tbl91__tbl_txt, :second_quantity_description)).
              select_more(Sequel.as(:tbl92__tbl_txt, :third_quantity_description)).
              join_table(:left, :chief_tbl9, {tbl91__tbl_code: :chief_comm__uoq_code_cdu2,
                                              tbl91__tbl_type: 'UNOQ'}, table_alias: :tbl91).
              join_table(:left, :chief_tbl9, {tbl92__tbl_code: :chief_comm__uoq_code_cdu3,
                                              tbl92__tbl_type: 'UNOQ'}, table_alias: :tbl92).
              filter{~{chief_comm__uoq_code_cdu2: nil} | ~{chief_comm__uoq_code_cdu3: nil}}.
              order(:chief_comm__audit_tsmp.desc)

  set_primary_key  :tbl_code

  def national_measurement_unit_set_units
    [NationalMeasurementUnit.new(measurement_unit_code: second_quantity_code,
                                 description: second_quantity_description,
                                 level: 2),
     NationalMeasurementUnit.new(measurement_unit_code: third_quantity_code,
                                 description: third_quantity_description,
                                 level: 3)]
  end
end
