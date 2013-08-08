Sequel.migration do
  up do
    drop_table :users

    create_table :users do
      primary_key :id
      String :uid
      String :name
      String :email
      Integer :version
      Text :permissions
      TrueClass :remotely_signed_out
      DateTime :updated_at
      DateTime :created_at
    end
  end

  down do
    drop_table :users

    create_table :users do
      primary_key :uid
      String :name
      String :email
      Text :permissions
      TrueClass :remotely_signed_out
    end
  end
end
