module ChiefDataHelper
  def preload_standing_data
    load(File.join(Rails.root, 'db', 'chief_standing_data.rb'))
  end

  def clear_standing_data
    [Chief::CountryCode, Chief::CountryGroup, Chief::MeasureTypeAdco, Chief::DutyExpression,
     Chief::MeasureTypeCond, Chief::MeasureTypeFootnote, Chief::MeasurementUnit].each do |chief_model|
      chief_model.truncate
    end
  end
end
