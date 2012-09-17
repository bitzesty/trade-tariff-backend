require 'csv'

CSV.foreach("#{Rails.root}/db/chief/chief_country_code.csv", :headers => true) do |row|
  Chief::CountryCode.insert(row.to_hash.delete_if{|k,v| v == 'nil'})
end

CSV.foreach("#{Rails.root}/db/chief/chief_country_group.csv", :headers => true) do |row|
  Chief::CountryGroup.insert(row.to_hash.delete_if{|k,v| v == 'nil'})
end

CSV.foreach("#{Rails.root}/db/chief/chief_duty_expression.csv", :headers => true) do |row|
  Chief::DutyExpression.insert(row.to_hash.delete_if{|k,v| v == 'nil'})
end

CSV.foreach("#{Rails.root}/db/chief/chief_measure_type_adco.csv", :headers => true) do |row|
  Chief::MeasureTypeAdco.insert(row.to_hash.delete_if{|k,v| v == 'nil'})
end

CSV.foreach("#{Rails.root}/db/chief/chief_measure_type_cond.csv", :headers => true) do |row|
  Chief::MeasureTypeCond.insert(row.to_hash.delete_if{|k,v| v == 'nil'})
end

CSV.foreach("#{Rails.root}/db/chief/chief_measure_type_footnote.csv", :headers => true) do |row|
  Chief::MeasureTypeFootnote.insert(row.to_hash.delete_if{|k,v| v == 'nil'})
end

CSV.foreach("#{Rails.root}/db/chief/chief_measurement_unit.csv", :headers => true) do |row|
  Chief::MeasurementUnit.insert(row.to_hash.delete_if{|k,v| v == 'nil'})
end
