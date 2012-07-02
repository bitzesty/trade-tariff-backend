class CreateProrogationRegulationActions < ActiveRecord::Migration
  def change
    create_table :prorogation_regulation_actions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :prorogation_regulation_role
      t.string :prorogation_regulation_id
      t.integer :prorogated_regulation_role
      t.string :prorogated_regulation_id
      t.date :prorogated_date

      t.timestamps
    end
  end
end
