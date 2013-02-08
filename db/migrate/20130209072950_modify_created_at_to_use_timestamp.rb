Sequel.migration do
  up do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates])}
                    .each do |table_name|
      if Sequel::Model.db[table_name].columns.include?(:created_at)
        alter_table table_name do
          set_column_type :created_at, Time, default: Sequel::CURRENT_TIMESTAMP
        end
      end
    end
  end

  down do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates])}
                    .each do |table_name|
      if Sequel::Model.db[table_name].columns.include?(:created_at)
        alter_table table_name do
          set_column_type :created_at, DateTime
        end
      end
    end
  end
end
