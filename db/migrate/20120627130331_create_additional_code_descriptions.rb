class CreateAdditionalCodeDescriptions < ActiveRecord::Migration
  def change
    create_table :additional_code_descriptions do |t|
      t.string :additional_code_description_period_sid
      t.string :language_id
      t.string :additional_code_sid
      t.string :additional_code_type_id
      t.string :additional_code
      t.text :description

      t.timestamps
    end
  end
end
