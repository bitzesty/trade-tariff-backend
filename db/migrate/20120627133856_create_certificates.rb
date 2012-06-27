class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :certificate_type_code
      t.string :certificate_code
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
