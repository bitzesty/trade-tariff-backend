class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
