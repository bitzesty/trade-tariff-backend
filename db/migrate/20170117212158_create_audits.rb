Sequel.migration do
  change do
    create_table :audits do
      primary_key :id
      integer :auditable_id, null: false
      String :auditable_type, null: false
      String :action, null: false
      json :changes, null: false
      integer :version, null: false
    end
  end
end
