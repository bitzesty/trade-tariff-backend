class CreateAdditionalCodeTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :additional_code_type_descriptions do |t|
      t.integer :additional_code_type_id
      t.integer :language_id
      t.text :short_description

      t.timestamps
    end
  end
end
