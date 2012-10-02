module ChiefDataHelper
  def preload_standing_data
    load(File.join(Rails.root, 'db', 'chief_standing_data.rb'))

    # File.readlines(Rails.root.join('db', 'chief', 'static_national_data_insert.sql')).each do |line|
    #   Sequel::Model.db.run(line.strip)
    # end
  end

  def clear_standing_data
    # File.readlines(Rails.root.join('db', 'chief', 'static_national_data_delete.sql')).each do |line|
    #   Sequel::Model.db.run(line)
    # end

    [Chief::CountryCode, Chief::CountryGroup, Chief::MeasureTypeAdco, Chief::DutyExpression,
     Chief::MeasureTypeCond, Chief::MeasureTypeFootnote, Chief::MeasurementUnit].each do |chief_model|
      chief_model.truncate
    end
  end
end
