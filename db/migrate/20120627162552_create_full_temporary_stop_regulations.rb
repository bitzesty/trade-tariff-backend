class CreateFullTemporaryStopRegulations < ActiveRecord::Migration
  def change
    create_table :full_temporary_stop_regulations, :id => false do |t|
      t.integer :full_temporary_stop_regulation_role
      t.string :full_temporary_stop_regulation_id
      t.date :published_date
      t.string :officialjournal_number
      t.integer :officialjournal_page
      t.date :validity_start_date
      t.date :validity_end_date
      t.date :effective_enddate
      t.integer :explicit_abrogation_regulation_role
      t.string :explicit_abrogation_regulation_id
      t.integer :replacement_indicator
      t.text :information_text
      t.boolean :approved_flag

      t.timestamps
    end
  end
end
