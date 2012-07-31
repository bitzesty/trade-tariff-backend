Sequel.migration do
  up do
    alter_table :measures do
      add_index :goods_nomenclature_item_id
    end
  end

  down do
    alter_table :measures do
      drop_index :goods_nomenclature_item_id
    end
  end
end
