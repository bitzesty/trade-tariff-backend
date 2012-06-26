class CreateRegulationGroups < ActiveRecord::Migration
  def change
    create_table :regulation_groups do |t|
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
