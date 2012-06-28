class CreateProrogationRegulationActions < ActiveRecord::Migration
  def change
    create_table :prorogation_regulation_actions, :id => false do |t|
      t.integer :prorogation_regulation_role
      t.string :prorogation_regulation_id
      t.integer :prorogated_regulation_role
      t.string :prorogated_regulation_id
      t.date :prorogated_date

      t.timestamps
    end
  end
end
