Sequel.migration do
  up do
    alter_table :measures do
      add_index :export_refund_nomenclature_sid
    end

    alter_table :export_refund_nomenclatures do
      set_column_type :additional_code_type, String, size: 1
      set_column_type :export_refund_code,   String, size: 3
      set_column_type :productline_suffix,   String, size: 2
    end
  end

  down do
    alter_table :measures do
      drop_index :export_refund_nomenclature_sid
    end

    alter_table :export_refund_nomenclatures do
      set_column_type :additional_code_type, String, size: 255
      set_column_type :export_refund_code,   String, size: 255
      set_column_type :productline_suffix,   String, size: 255
    end
  end
end
