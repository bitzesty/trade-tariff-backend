require 'tariff_synchronizer'
require 'green_pages'

namespace :tariff do
  desc 'Installs Trade Tariff, creates relevant records, imports national data'
  task install: %w[environment
                   install:taric:sections
                   install:taric:section_notes
                   install:taric:chapter_notes
                   install:chief:static_national_data
                   install:chief:standing_data
                   reindex]

  desc 'Reindex relevant entities on ElasticSearch'
  task reindex: %w[environment
                   install:green_pages] do
    ENV['FORCE'] = 'true'
    ['Section','Chapter','Heading','Commodity','SearchReference'].each do |klass|
      ENV['CLASS'] = klass
      Rake::Task['tire:import'].execute
    end
  end

  desc 'Download and apply Taric and CHIEF data'
  task sync: %w[environment sync:apply]

  namespace :sync do
    desc 'Download pending Taric and CHIEF updates'
    task apply: :environment do
      TradeTariffBackend.with_locked_database do
        # Download pending updates for CHIEF and Taric
        TariffSynchronizer.download
        TariffSynchronizer.apply
      end
    end

    desc 'Apply pending Taric and CHIEF'
    task transform: %w[environment] do
      require 'chief_transformer'

      TradeTariffBackend.with_locked_database do
        # Apply pending updates (use TariffImporter to import record to database)
        # Transform imported intermediate Chief records to insert/change national measures

        mode = ENV["MODE"].try(:to_sym).presence || :update

        ChiefTransformer.instance.invoke(mode)
        # Reindex ElasticSearch to see new/updated commodities
        Rake::Task['tariff:reindex'].execute
      end
    end
  end

  namespace :install do
    desc "Load Green Page (SearchReference) entities from reference file"
    task green_pages: :environment do
      GreenPages.reload
    end

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

      desc "Load Chief Standing data used for Transformation"
      task standing_data: :environment do
        load(File.join(Rails.root, 'db', 'chief_standing_data.rb'))
      end
    end
  end

  desc 'Removes additional Trade Tariff entries'
  task remove: %w[environment
                  remove:taric:sections
                  remove:chief:standing_data
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

      desc "Remove CHIEF standing data"
      task standing_data: :environment do
        [Chief::CountryCode, Chief::CountryGroup, Chief::MeasureTypeAdco, Chief::DutyExpression,
         Chief::MeasureTypeCond, Chief::MeasureTypeFootnote, Chief::MeasurementUnit].each do |chief_model|
          chief_model.truncate
        end
      end
    end
  end
end
