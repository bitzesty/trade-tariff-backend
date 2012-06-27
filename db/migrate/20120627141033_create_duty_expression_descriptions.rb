class CreateDutyExpressionDescriptions < ActiveRecord::Migration
  def change
    create_table :duty_expression_descriptions, :id => false do |t|
      t.string :duty_expression_id
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
