Sequel.migration do
  change do
    alter_table :chief_duty_expression do
      set_column_type :adval1_rate, TrueClass, using: "adval1_rate::boolean"
      set_column_type :adval2_rate, TrueClass, using: "adval2_rate::boolean"
      set_column_type :spfc1_rate, TrueClass, using: "spfc1_rate::boolean"
      set_column_type :spfc2_rate, TrueClass, using: "spfc2_rate::boolean"
    end
  end
end
