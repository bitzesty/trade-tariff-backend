class CreateRegulationRoleTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :regulation_role_type_descriptions do |t|
      t.integer :regulation_role_type_id
      t.integer :nguage_id
      t.text :short_description

      t.timestamps
    end
  end
end
