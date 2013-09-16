Sequel.migration do
  up do
    alter_table :search_references do
      add_column :heading_id, String, size: 4
      add_column :chapter_id, String, size: 2
      add_column :section_id, :integer

      add_index :heading_id
      add_index :chapter_id
      add_index :section_id

      drop_column :reference
    end
  end

  down do
    alter_table :search_references do
      drop_column :heading_id
      drop_column :chapter_id
      drop_column :section_id

      add_column :reference, String
    end
  end
end
