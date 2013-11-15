Sequel.migration do
  up do
    alter_table(:search_references) do
      add_column :referenced_id, String, size: 10
      add_column :referenced_class, String, size: 10
    end

    add_index :search_references, [:referenced_id, :referenced_class]

    self[:search_references].each { |search_reference|
      if search_reference[:heading_id].present?
        self[:search_references].where(
          id: search_reference[:id]
        ).update(
          referenced_id: search_reference[:heading_id],
          referenced_class: 'Heading'
        )
      elsif search_reference[:chapter_id].present?
        self[:search_references].where(
          id: search_reference[:id]
        ).update(
          referenced_id: search_reference[:chapter_id],
          referenced_class: 'Chapter'
        )
      elsif search_reference[:section_id].present?
        self[:search_references].where(
          id: search_reference[:id]
        ).update(
          referenced_id: search_reference[:section_id],
          referenced_class: 'Section'
        )
      end
    }

    alter_table(:search_references) do
      drop_column :heading_id
      drop_column :chapter_id
      drop_column :section_id
    end
  end

  down do
    alter_table(:search_references) do
      add_column :heading_id, String, size: 4
      add_column :chapter_id, String, size: 2
      add_column :section_id, Integer
    end

    self[:search_references].each { |search_reference|
      if search_reference[:referenced_class] == 'Heading'
        self[:search_references].where(
          id: search_reference[:id]
        ).update(
          heading_id: search_reference[:referenced_id]
        )
      end

      if search_reference[:referenced_class] == 'Chapter'
        self[:search_references].where(
          id: search_reference[:id]
        ).update(
          chapter_id: search_reference[:referenced_id]
        )
      end

      if search_reference[:referenced_class] == 'Section'
        self[:search_references].where(
          id: search_reference[:id]
        ).update(
          section_id: search_reference[:referenced_id]
        )
      end
    }

    alter_table(:search_references) do
      drop_column :referenced_id
      drop_column :referenced_class
    end
  end
end
