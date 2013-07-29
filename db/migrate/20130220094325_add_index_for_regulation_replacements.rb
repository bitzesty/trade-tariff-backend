Sequel.migration do
  up do
    alter_table :regulation_replacements_oplog do
      add_index [:replaced_regulation_role, :replaced_regulation_id], name: :rr_pk
    end
  end

  down do
    alter_table :regulation_replacements_oplog do
      drop_index [:replaced_regulation_role, :replaced_regulation_id], name: :rr_pk
    end
  end
end
