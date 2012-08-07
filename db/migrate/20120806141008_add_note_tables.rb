Sequel.migration do
  up do
    create_table :section_notes do
      primary_key :id
      foreign_key :section_id, :sections
      String :content, text: true
    end

    create_table :chapter_notes do
      primary_key :id
      foreign_key :section_id, :sections
      Integer :chapter_id, index: true
      String :content, text: true
    end
  end

  down do
    drop_table :section_notes
    drop_table :chapter_notes
  end
end
