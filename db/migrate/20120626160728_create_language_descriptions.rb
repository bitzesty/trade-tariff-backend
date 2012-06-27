class CreateLanguageDescriptions < ActiveRecord::Migration
  def change
    create_table :language_descriptions, :id => false do |t|
      t.string :language_code_id
      t.string :language_id
      t.text :description
      t.timestamps
    end
  end
end
