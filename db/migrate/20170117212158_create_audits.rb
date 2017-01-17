Sequel.migration do
  change do
    create_table :audits do
      primary_key :id
      Integer :auditable_id, null: false
      String :auditable_type, null: false
      String :action, null: false
      String :changes, null: false, text: true
      Integer :version, null: false
    end
  end
end
