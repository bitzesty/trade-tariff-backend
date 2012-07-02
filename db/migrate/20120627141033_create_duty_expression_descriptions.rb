class CreateDutyExpressionDescriptions < ActiveRecord::Migration
  def change
    create_table :duty_expression_descriptions, :id => false do |t|
      t.string :record_code
      t.string :subrecord_code
      t.string :record_sequence_number
      
      t.string :duty_expression_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
