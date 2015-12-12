Sequel.migration do
  no_transaction

  up do
    alter_table :meursing_additional_codes do
      set_column_type :additional_code, String, using: "additional_code::text", size: 3
    end

    alter_table :meursing_table_cell_components do
      set_column_type :additional_code, String, using: "additional_code::text", size: 3
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
      set_column_type :additional_code, Integer, using: "additional_code::integer"
    end

    alter_table :meursing_table_cell_components do
      set_column_type :additional_code, Integer, using: "additional_code::integer"
    end
  end
end
