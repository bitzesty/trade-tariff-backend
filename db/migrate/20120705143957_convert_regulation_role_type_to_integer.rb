class ConvertRegulationRoleTypeToInteger < ActiveRecord::Migration
  def up
    change_column :regulation_role_types, :regulation_role_type_id, :integer
  end

  def down
    change_column :regulation_role_types, :regulation_role_type_id, :string
  end
end
