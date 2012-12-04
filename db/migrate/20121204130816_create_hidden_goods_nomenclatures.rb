Sequel.migration do
  change do
    create_table :hidden_goods_nomenclatures do
      String   :goods_nomenclature_item_id
      DateTime :updated_at
      DateTime :created_at
    end
  end
end
