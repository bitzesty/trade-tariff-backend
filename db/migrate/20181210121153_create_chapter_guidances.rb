Sequel.migration do
  change do
    create_table :chapter_guidances do
      primary_key :id
      String :title
      String :url
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
    create_table :chapter_guidances_chapters do
      primary_key :id
      integer :chapter_id
      integer :chapter_guidance_id
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
