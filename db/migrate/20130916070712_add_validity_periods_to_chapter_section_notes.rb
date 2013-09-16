Sequel.migration do
  up do
    alter_table :chapter_notes do
      add_column :validity_start_date, DateTime
      add_column :validity_end_date, DateTime
    end

    alter_table :section_notes do
      add_column :validity_start_date, DateTime
      add_column :validity_end_date, DateTime
    end

    run "UPDATE chapter_notes SET validity_start_date = '1972-12-31'"
    run "UPDATE section_notes SET validity_start_date = '1972-12-31'"
  end

  down do
    alter_table :chapter_notes do
      drop_column :validity_start_date
      drop_column :validity_end_date
    end

    alter_table :section_notes do
      drop_column :validity_start_date
      drop_column :validity_end_date
    end
  end
end
