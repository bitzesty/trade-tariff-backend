Sequel.migration do
  up do
    alter_table :certificate_types do
      drop_index [:certificate_type_code], name: :primary_key
      add_index [:certificate_type_code, :validity_start_date], name: :primary_key
    end
  end

  down do
    alter_table :certificate_types do
      drop_index [:certificate_type_code, :validity_start_date], name: :primary_key
      add_index [:certificate_type_code], name: :primary_key
    end
  end
end
