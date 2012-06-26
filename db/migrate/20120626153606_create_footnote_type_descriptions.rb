class CreateFootnoteTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :footnote_type_descriptions do |t|
      t.integer :footnote_type_id
      t.integer :language_id
      t.text :short_description
      t.timestamps
    end
  end
end
