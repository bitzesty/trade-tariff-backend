class CreateQuotaOrderNumberOriginExclusions < ActiveRecord::Migration
  def change
    create_table :quota_order_number_origin_exclusions, :id => false do |t|
      t.integer :quota_order_number_origin_sid
      t.integer :excluded_geographical_area_sid

      t.timestamps
    end
  end
end
