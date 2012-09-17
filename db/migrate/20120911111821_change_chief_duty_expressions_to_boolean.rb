Sequel.migration do
  change do
    alter_table :chief_duty_expression do
      set_column_type :adval1_rate, TrueClass
      set_column_type :adval2_rate, TrueClass
      set_column_type :spfc1_rate, TrueClass
      set_column_type :spfc2_rate, TrueClass
    end
  end
end
