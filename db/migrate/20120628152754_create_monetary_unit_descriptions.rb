class CreateMonetaryUnitDescriptions < ActiveRecord::Migration
  def change
    create_table :monetary_unit_descriptions, :id => false do |t|
      t.string :monetary_unit_code
      t.string :language_id
      t.text :description

      t.timestamps
    end
  end
end
