class CreateDutyExpressions < ActiveRecord::Migration
  def change
    create_table :duty_expressions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :duty_expression_id
      t.date :validity_start_date
      t.date :validity_end_date
      t.integer :duty_amount_applicability_code
      t.integer :measurement_unit_applicability_code
      t.integer :monetary_unit_applicability_code

      t.timestamps
    end
  end
end
