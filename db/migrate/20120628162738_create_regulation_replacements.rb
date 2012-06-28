class CreateRegulationReplacements < ActiveRecord::Migration
  def change
    create_table :regulation_replacements, :id => false do |t|
      t.integer :replacing_regulation_role
      t.string :replacing_regulation_id
      t.integer :replaced_regulation_role
      t.string :replaced_regulation_id

      t.timestamps
    end
  end
end
