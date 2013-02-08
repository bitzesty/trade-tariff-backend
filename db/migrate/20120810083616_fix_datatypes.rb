Sequel.migration do
  up do
    alter_table :export_refund_nomenclature_description_periods do
      set_column_type :additional_code_type, String
    end

    alter_table :export_refund_nomenclature_descriptions do
      set_column_type :additional_code_type, String
    end

    alter_table :export_refund_nomenclature_indents do
      set_column_type :additional_code_type, String
    end

    alter_table :export_refund_nomenclatures do
      set_column_type :additional_code_type, String
    end

    alter_table :footnote_association_additional_codes do
      set_column_type :additional_code_type_id, String
    end

    alter_table :footnote_association_erns do
      set_column_type :additional_code_type, String
    end

    alter_table :measures do
      set_column_type :additional_code_type_id, String
    end
  end

  down do
    alter_table :export_refund_nomenclature_description_periods do
      set_column_type :additional_code_type, Integer
    end

    alter_table :export_refund_nomenclature_descriptions do
      set_column_type :additional_code_type, Integer
    end

    alter_table :export_refund_nomenclature_indents do
      set_column_type :additional_code_type, Integer
    end

    alter_table :export_refund_nomenclatures do
      set_column_type :additional_code_type, Integer
    end

    alter_table :footnote_association_additional_codes do
      set_column_type :additional_code_type_id, Integer
    end

    alter_table :footnote_association_erns do
      set_column_type :additional_code_type, Integer
    end

    alter_table :measures do
      set_column_type :additional_code_type, Integer
    end
  end
end
