Sequel.migration do
  up do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
      rename_table table_name, :"#{table_name}_oplog"
    end
  end

  down do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
      rename_table table_name, table_name.to_s.split("_oplog").first
    end
  end
end
