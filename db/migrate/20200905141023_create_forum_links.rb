Sequel.migration do
  change do
    create_table :forum_links do
      primary_key :id
      String :url
      integer :goods_nomenclature_sid
      Time :created_at
      index :goods_nomenclature_sid
    end
  end
end
