class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages, :id => false do |t|
      t.string :language_id
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
