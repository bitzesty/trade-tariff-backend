namespace :db do
  desc "Import Chief standing data"
  task chief: 'environment' do
    load(File.join(Rails.root, 'db', 'chief_standing_data.rb'))
  end

  desc "Clear chief data"
  task clear_chief: 'environment' do
    [Chief::CountryCode, Chief::CountryGroup, Chief::DutyExpression, Chief::MeasureTypeAdco, Chief::MeasureTypeCond, Chief::MeasureTypeFootnote, Chief::MeasurementUnit].each do |r|
      r.delete
    end
  end
end
