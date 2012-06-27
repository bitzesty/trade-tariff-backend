class CreateCertificateTypes < ActiveRecord::Migration
  def change
    create_table :certificate_types, :id => false do |t|
      t.string :certificate_type_code
      t.date :validity_start_date
      t.date :validity_end_date
      t.timestamps
    end
  end
end
