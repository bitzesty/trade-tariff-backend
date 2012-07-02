class CreateBaseRegulations < ActiveRecord::Migration
  def change
    create_table :base_regulations, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.integer :base_regulation_role
      t.string :base_regulation_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :community_code
      t.string :regulation_group_id
      t.integer :replacement_indicator
      t.boolean :stopped_flag
      t.text :information_text
      t.boolean :approved_flag
      t.date :published_date
      t.string :officialjournal_number
      t.integer :officialjournal_page
      t.date :effective_end_date
      t.integer :replacement_indicator
      t.boolean :stopped_flag
      t.integer :antidumping_regulation_role
      t.string :related_antidumping_regulation_id
      t.integer :complete_abrogation_regulation_role
      t.string :complete_abrogation_regulation_id
      t.integer :explicit_abrogation_regulation_role
      t.string :explicit_abrogation_regulation_id
      t.timestamps
    end
  end
end
