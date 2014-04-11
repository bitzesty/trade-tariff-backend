Sequel.migration do
  change do

    create_table :rollbacks do
      primary_key :id
      Integer :user_id
      Date :date
      TrueClass :redownload
      DateTime :enqueued_at
      String :reason, text: true

      index [:user_id], name: :user_id
    end

  end
end
