class CreateFtsRegulationActions < ActiveRecord::Migration
  def change
    create_table :fts_regulation_actions, :id => false do |t|
      t.integer :fts_regulation_role
      t.string :fts_regulation_id
      t.integer :stopped_regulation_role
      t.string :stopped_regulation_id

      t.timestamps
    end
  end
end
