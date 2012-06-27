class CreateCertificateDescriptionPeriods < ActiveRecord::Migration
  def change
    create_table :certificate_description_periods, :id => false do |t|
      t.string :certificate_description_period_sid
      t.string :certificate_type_code
      t.string :certificate_code
      t.date :validity_start_date

      t.timestamps
    end
  end
end
