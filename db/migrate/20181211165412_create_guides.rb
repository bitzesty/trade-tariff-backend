Sequel.migration do
  change do
    create_table :guides do
      primary_key :id
      String :title
      String :url
    end

    create_table :chapters_guides do
      primary_key :id
      integer :goods_nomenclature_sid
      integer :guide_id
    end
  end
end
