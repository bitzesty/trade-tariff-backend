Sequel.migration do
  change do
    create_table :tariff_updates do
      String :filename, primary_key: true, size: 30
      String :update_type, size: 15
      String :state, size: 1
      Date :issue_date
      Time :updated_at
      Time :created_at
    end
  end
end
