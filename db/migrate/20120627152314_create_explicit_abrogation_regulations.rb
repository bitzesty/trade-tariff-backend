class CreateExplicitAbrogationRegulations < ActiveRecord::Migration
  def change
    create_table :explicit_abrogation_regulations, :id => false do |t|
      t.integer :explicit_abrogation_regulation_role
      t.string  :explicit_abrogation_regulation_id
      t.date :published_date
      t.string :officialjournal_number
      t.integer :officialjournal_page
      t.integer :replacement_indicator
      t.date :abrogation_date
      t.text :information_text
      t.boolean :approved_flag

      t.timestamps
    end
  end
end
