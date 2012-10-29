Sequel.migration do
  up do
    alter_table :meursing_additional_codes do
      set_column_type :additional_code, String, size: 3
    end

    alter_table :meursing_table_cell_components do
      set_column_type :additional_code, String, size: 3
    end

    MeursingAdditionalCode.each do |madco|
      madco.update additional_code: "%03d" % madco.additional_code
    end

    MeursingTableCellComponent.each do |mtcc|
      mtcc.update additional_code: "%03d" % mtcc.additional_code
    end
  end

  down do
    alter_table :meursing_additional_codes do
      set_column_type :additional_code, Integer
    end

    alter_table :meursing_table_cell_components do
      set_column_type :additional_code, Integer
    end
  end
end
