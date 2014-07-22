Sequel.migration do
  change do
    alter_table :tariff_updates do
      add_column :exception_backtrace, String, text: true
      add_column :exception_queries, String, text: true
      add_column :exception_class, String
    end
  end
end
