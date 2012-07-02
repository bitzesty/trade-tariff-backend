class CreateQuotaOrderNumberOrigins < ActiveRecord::Migration
  def change
    create_table :quota_order_number_origins, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :quota_order_number_origin_sid
      t.integer :quota_order_number_sid
      t.string :geographical_area_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :geographical_area_sid

      t.timestamps
    end
  end
end
