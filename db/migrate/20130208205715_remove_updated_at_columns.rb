Sequel.migration do
  up do
    Sequel::Model.db.tables
                    .reject{|t_name| t_name.in?([:tariff_updates])}
                    .each do |table_name|
      if Sequel::Model.db[table_name].columns.include?(:updated_at)
        alter_table table_name do
          drop_column :updated_at
        end
      end
    end
  end

  down do
    # Do not need to reverse this
    # We don't store anything in updated_at
  end
end
