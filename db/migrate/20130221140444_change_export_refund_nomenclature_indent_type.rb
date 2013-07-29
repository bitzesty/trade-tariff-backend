Sequel.migration do
  up do
    alter_table :export_refund_nomenclature_indents_oplog do
      set_column_type :number_export_refund_nomenclature_indents, Integer
    end
  end

  down do
    alter_table :export_refund_nomenclature_indents_oplog do
      set_column_type :number_export_refund_nomenclature_indents, String
    end
  end
end
