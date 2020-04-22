Sequel.migration do
  change do
    create_table :chemicals do
      primary_key :id
      String :cas
      unique :cas
      index [:cas]
    end

    create_table :chemical_names do
      primary_key :id
      foreign_key :chemical_id, :chemicals
      String :name
      index [:name, :chemical_id]
    end

    create_table :chemicals_goods_nomenclatures do
      integer :chemical_id
      integer :goods_nomenclature_sid
      primary_key [:chemical_id, :goods_nomenclature_sid]
      index [:chemical_id, :goods_nomenclature_sid]
    end
  end
end
