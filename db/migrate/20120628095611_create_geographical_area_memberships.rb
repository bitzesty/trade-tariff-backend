class CreateGeographicalAreaMemberships < ActiveRecord::Migration
  def change
    create_table :geographical_area_memberships do |t|
      t.integer :geographical_area_sid
      t.integer :geographical_area_group_sid
      t.date :validity_start_date

      t.timestamps
    end
  end
end
