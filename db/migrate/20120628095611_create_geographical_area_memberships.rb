class CreateGeographicalAreaMemberships < ActiveRecord::Migration
  def change
    create_table :geographical_area_memberships, :id => false do |t|
      t.integer :geographical_area_sid
      t.integer :geographical_area_group_sid
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
