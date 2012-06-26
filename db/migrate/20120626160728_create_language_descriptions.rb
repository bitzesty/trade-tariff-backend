class CreateLanguageDescriptions < ActiveRecord::Migration
  def change
    create_table :language_descriptions, :id => false do |t|
      t.string :id
      t.string :language_id
      t.text :name

      t.timestamps
    end
  end
end
