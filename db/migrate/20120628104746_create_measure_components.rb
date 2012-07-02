class CreateMeasureComponents < ActiveRecord::Migration
  def change
    create_table :measure_components, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number

      t.integer :measure_sid
      t.string :duty_expression_id
      t.integer :duty_amount
      t.string :monetary_unit_code
      t.string :measurement_unit_code
      t.string :measurement_unit_qualifier_code

      t.timestamps
    end
  end
end
