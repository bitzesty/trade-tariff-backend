namespace :db do
  desc 'Create Sections'
  task import: 'environment' do
    load(File.join(Rails.root, 'db', 'import.rb'))
  end

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

  desc "Load Section notes"
  task section_notes: 'environment' do
    Dir[Rails.root.join('db','notes','sections','*')].each do |file|
      begin
        note = YAML.load(File.read(file))
        SectionNote.find_or_create(section_id: note[:section]) { |sn|
          sn.content = note[:content]
        }
      rescue
        puts "Error loading: #{file}"
      end
    end
  end

  desc "Load Chapter notes"
  task chapter_notes: 'environment' do
    Dir[Rails.root.join('db','notes','chapters','*')].each do |file|
      begin
        note = YAML.load(File.read(file))
        ChapterNote.find_or_create(section_id: note[:section],
                                   chapter_id: note[:chapter]) { |cn|
          cn.content = note[:content]
        }
      rescue
        puts "Error loading: #{file}"
      end
    end
  end
end
