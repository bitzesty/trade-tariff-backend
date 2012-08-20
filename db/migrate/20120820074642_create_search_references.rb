Sequel.migration do
  change do
    create_table :search_references do
      primary_key :id
      String :title
      String :reference
    end
  end
end
