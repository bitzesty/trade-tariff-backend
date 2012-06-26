class CreateFootnoteTypes < ActiveRecord::Migration
  def change
    create_table :footnote_types do |t|
      t.integer :code
      t.date :validity_start_date
      t.date :validity_end_date
      t.timestamps
    end
  end
end
