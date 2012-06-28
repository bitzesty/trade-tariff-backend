class CreateProrogationRegulations < ActiveRecord::Migration
  def change
    create_table :prorogation_regulations, :id => false do |t|
      t.integer :prorogation_regulation_role
      t.string :prorogation_regulation_id
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
