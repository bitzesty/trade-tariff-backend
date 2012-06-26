class CreateCertificateTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :certificate_type_descriptions do |t|
      t.integer :certificate_type_id
      t.integer :language_id
      t.text :short_description
      t.timestamps
    end
  end
end
