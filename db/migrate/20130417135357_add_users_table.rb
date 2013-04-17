Sequel.migration do
  up do
    create_table :users do
      primary_key :uid
      String      :name
      String      :email
      String      :permission, text: true
      TrueClass   :remotely_signed_out, default: false
    end
  end

  down do
    drop_table :users
  end
end
