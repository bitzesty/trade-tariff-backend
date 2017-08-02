Sequel.migration do
  change do
    create_table :cas_numbers do
      primary_key :id
      String :title
      String :reference, size: 10
    end
  end
end
