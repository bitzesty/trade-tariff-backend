require 'tariff_synchronizer'

namespace :tariff do
  desc 'Installs Trade Tariff, creates relevant records, imports national data'
  task install: %w[environment
                   install:taric:sections
                   install:taric:section_notes
                   install:taric:chapter_notes
                   reindex]

  desc 'Reindex relevant entities on ElasticSearch'
  task reindex: :environment do
    ENV['FORCE'] = 'true'
    ['Section','Chapter','Heading','Commodity'].each do |klass|
      ENV['CLASS'] = klass
      Rake::Task['tire:import'].execute
    end
  end

  desc 'Download and apply Taric and CHIEF data'
  task sync: %w[environment sync:download sync:apply]

  namespace :sync do
    desc 'Download pending Taric and CHIEF updates'
    task download: :environment do
      TariffSynchronizer.download
    end

    desc 'Apply pending Taric and CHIEF'
    task apply: :environment do
      TariffSynchronizer.apply
    end

    desc 'Retry applying updates in failbox'
    task retry: :environment do
      TariffSynchronizer.retry
    end
  end

  namespace :install do
    namespace :taric do
      desc "Add Sections and associate to Chapters"
      task sections: :environment do
        load(File.join(Rails.root, 'db', 'import_sections.rb'))
      end

      desc "Load Section notes into database"
      task section_notes: :environment do
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

      desc "Load Chapter notes into database"
      task chapter_notes: :environment do
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

    namespace :chief do
      desc "Load Static National Data"
      task static_national_data: :environment do
        Sequel::Model.db.transaction do
          File.readlines(Rails.root.join('db', 'chief', 'static_national_data_insert.sql')).each do |line|
            Sequel::Model.db.run(line.strip)
          end
        end
      end
    end
  end

  desc 'Removes additional Trade Tariff entries'
  task remove: %w[environment
                  remove:taric:sections
                  remove:chief:static_national_data]

  namespace :remove do
    namespace :taric do
      desc "Remove Sections and Chapter<->Section association records"
      task sections: :environment do
        Section.delete
        Sequel::Model.db.run('DELETE FROM chapters_sections');
      end
    end

    namespace :chief do
      desc "Remove Static National data for CHIEF"
      task static_national_data: :environment do
        Sequel::Model.db.transaction do
          File.readlines(Rails.root.join('db', 'chief', 'static_national_data_delete.sql')).each do |line|
            Sequel::Model.db.run(line)
          end
        end
      end
    end
  end
end
