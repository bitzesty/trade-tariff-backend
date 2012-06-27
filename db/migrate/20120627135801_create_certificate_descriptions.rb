class CreateCertificateDescriptions < ActiveRecord::Migration
  def change
    create_table :certificate_descriptions, :id => false do |t|
      t.string :certificate_description_period_sid
      t.string :language_id
      t.string :certificate_type_code
      t.string :certificate_code
      t.text :description

      t.timestamps
    end
  end
end
