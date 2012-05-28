namespace :db do
  desc "Import XLS data"
  task import: 'environment' do
    load(File.join(Rails.root, 'db', 'import.rb'))
  end

  desc "Clear data"
  task clear: 'environment' do
    [Measure, AdditionalCode, Footnote, LegalAct, Country, CountryGroup].each do |r|
      r.delete_all
    end
  end
end
