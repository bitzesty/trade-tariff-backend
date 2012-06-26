class CreateFootnoteDescriptions < ActiveRecord::Migration
  def change
    create_table :footnote_descriptions, :id => false do |t|
      t.string :sid
      t.string :footnote_type_id
      t.string :footnote_id
      t.string :language_id
      t.text :long_description

      t.timestamps
    end
  end
end
