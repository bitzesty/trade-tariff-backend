class CreateQuotaOrderNumbers < ActiveRecord::Migration
  def change
    create_table :quota_order_numbers, :id => false do |t|
      t.integer :quota_order_number_sid
      t.string :quota_order_number_id
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
