class CreateRegulationGroupDescriptions < ActiveRecord::Migration
  def change
    create_table :regulation_group_descriptions, :id => false do |t|
      t.string :id
      t.string :regulation_group_id
      t.string :language_id
      t.text :short_description

      t.timestamps
    end
  end
end
