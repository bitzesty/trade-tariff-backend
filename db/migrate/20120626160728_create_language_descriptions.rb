class CreateLanguageDescriptions < ActiveRecord::Migration
  def change
    create_table :language_descriptions do |t|
      t.integer :language_id
      t.text :name

      t.timestamps
    end
  end
end
