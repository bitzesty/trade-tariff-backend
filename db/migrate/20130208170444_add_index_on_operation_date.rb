Sequel.migration do
  up do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
      alter_table table_name do
        index_name = [
          table_name.to_s.split("_").map(&:first).join,
          table_name.to_s.split("_").map{|w| w.first(3)}.join,
          table_name.to_s.split("_").map{|w| w.last(3)}.join
        ]
        add_index :operation_date, name: :"#{index_name.join("_")}_operation_date"
      end
    end
  end

  down do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates, :sections, :schema_migrations])}
                    .reject{|t| t.to_s =~ /chief|chapter_notes|section_notes|chapters_sections|hidden|search/}.each do |table_name|
      alter_table table_name do
        drop_index :operation_date, name: :"#{table_name.to_s.split("_").map(&:first).join}_operation_date"
      end
    end
  end
end
