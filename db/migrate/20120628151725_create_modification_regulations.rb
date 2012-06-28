class CreateModificationRegulations < ActiveRecord::Migration
  def change
    create_table :modification_regulations, :id => false do |t|
      t.integer :modification_regulation_role
      t.string :modification_regulation_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.date :published_date
      t.string :officialjournal_number
      t.integer :officialjournal_page
      t.integer :base_regulation_role
      t.string :base_regulation_id
      t.integer :replacement_indicator
      t.boolean :stopped_flag
      t.text :information_text
      t.boolean :approved_flag
      t.integer :explicit_abrogation_regulation_role
      t.string :explicit_abrogation_regulation_id
      t.date :effective_end_date
      t.integer :complete_abrogation_regulation_role
      t.string :complete_abrogation_regulation_id

      t.timestamps
    end
  end
end
