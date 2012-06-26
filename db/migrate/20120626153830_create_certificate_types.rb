class CreateCertificateTypes < ActiveRecord::Migration
  def change
    create_table :certificate_types do |t|
      t.date :validity_start_date
      t.date :validity_end_date
      t.timestamps
    end
  end
end
