class CreateCompleteAbrogationRegulations < ActiveRecord::Migration
  def change
    create_table :complete_abrogation_regulations do |t|
      t.integer :complete_abrogation_regulation_role
      t.string :complete_abrogation_regulation_id
      t.date :published_date
      t.string :officialjournal_number
      t.integer :officialjournal_page
      t.integer :replacement_indicator
      t.text :information_text
      t.boolean :approved_flag

      t.timestamps
    end
  end
end
