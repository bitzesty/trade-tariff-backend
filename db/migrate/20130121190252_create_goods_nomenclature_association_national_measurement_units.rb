Sequel.migration do
  change do
    create_table :goods_nomenclature_association_national_measurement_units do
      Integer :goods_nomenclature_sid
      String  :measurement_unit_code, size: 3
      Integer :measurement_unit_quantity_level

      index [:goods_nomenclature_sid, :measurement_unit_code], :name=>:primary_key
    end
  end
end
