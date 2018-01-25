Sequel.migration do
  up do
    create_table :commodity_checks do
      primary_key :id

      String :commodity_code
      String :goods_nomenclature_sid
      String :producline_suffix
      String :status
    end
  end

  down do
    drop_table :commodity_checks
  end
end
