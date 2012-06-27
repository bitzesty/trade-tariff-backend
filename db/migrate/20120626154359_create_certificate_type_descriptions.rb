class CreateCertificateTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :certificate_type_descriptions, :id => false do |t|
      t.string :certificate_type_code
      t.string :language_id
      t.text :description
      t.timestamps
    end
  end
end
