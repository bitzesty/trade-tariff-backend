class CreateRegulationRoleTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :regulation_role_type_descriptions, :id => false do |t|
      t.string :regulation_role_type_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
