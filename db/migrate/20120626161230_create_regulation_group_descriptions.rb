class CreateRegulationGroupDescriptions < ActiveRecord::Migration
  def change
    create_table :regulation_group_descriptions do |t|
      t.integer :regulation_group_id
      t.integer :language_id
      t.text :short_description

      t.timestamps
    end
  end
end
