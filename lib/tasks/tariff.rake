namespace :tariff do
  desc 'Installs Trade Tariff, creates relevant records, imports national data'
  task install: %w[environment
                   install:taric:sections
                   install:taric:section_notes
                   install:taric:chapter_notes
                   install:chief:static_national_data
                   install:chief:standing_data]

  desc 'Reindex relevant entities on ElasticSearch'
  task reindex: %w[environment] do
    TradeTariffBackend.reindex
  end

  desc 'Download and apply Taric and CHIEF data'
  task sync: %w[environment sync:apply]

  desc "Restore missing chief records files"
  task restore_missing_chief_records: :environment do
    require "csv"

    # Custom converter
    CSV::Converters[:null_to_nil] = lambda do |field|
      field && field == "NULL" ? nil : field
    end

    ["comm", "tamf", "tbl9", "mfcm", "tame"].each do |table_name|
      file_path = File.join(Rails.root, "data", "missing_chief_records", "#{table_name}.csv")

      rows = CSV.read(file_path, headers: true, header_converters: :symbol, converters: [:null_to_nil])

      rows.each do |line|
        "Chief::#{table_name.capitalize}".constantize.insert line.to_hash
      end

      puts "#{table_name} table processed"
    end
  end

  desc "Process missing chief records files"
  task process_missing_chief_records: :environment do
    processor = ChiefTransformer::Processor.new(Chief::Mfcm.unprocessed.all, Chief::Tame.unprocessed.all)
    processor.process
  end

  namespace :sync do
    desc 'Update database by downloading and then applying CHIEF and TARIC updates via worker'
    task update: [:environment, :class_eager_load] do
      UpdatesSynchronizerWorker.perform_async
    end

    desc 'Download pending Taric and CHIEF update files, Update tariff_updates table'
    task download: [:environment, :class_eager_load] do
      TariffSynchronizer.download
    end

    desc 'Apply pending updates Taric and CHIEF'
    task apply: [:environment, :class_eager_load] do
      TariffSynchronizer.apply
    end

    desc 'Transform CHIEF updates'
    task transform: %w[environment] do
      require 'chief_transformer'
      # Transform imported intermediate Chief records to insert/change national measures

      mode = ENV["MODE"].try(:to_sym).presence || :update

      ChiefTransformer.instance.invoke(mode)
      # Reindex ElasticSearch to see new/updated commodities
      Rake::Task['tariff:reindex'].execute
    end

    desc 'Rollback to specific date in the past'
    task rollback: %w[environment class_eager_load] do
      if ENV['DATE']
        TariffSynchronizer.rollback(ENV['DATE'], ENV['KEEP'])
      else
        raise ArgumentError.new("Please set the date using environment variable 'DATE'")
      end
    end
  end

  namespace :install do
    desc "Load Green Page (SearchReference) entities from reference file"
    task green_pages: :environment do
      ImportSearchReferences.reload
    end

    namespace :taric do
      desc "Add Sections and associate to Chapters"
      task sections: :environment do
        load(File.join(Rails.root, 'db', 'import_sections.rb'))
      end

      desc "Dump Section notes"
      task dump_section_notes: :environment do
        section_note = SectionNote.all.each do |section_note|
          section_file = "db/notes/sections/#{section_note.section_id}.yaml"
          File.open(section_file, 'w') do |out|
            section_doc = {
              section: section_note.section_id,
              content: section_note.content
            }
            YAML::dump(section_doc, out)
          end
        end
      end


      desc "Load Section notes into database"
      task section_notes: :environment do
        Dir[Rails.root.join('db','notes','sections','*')].each do |file|
          begin
            note = YAML.load(File.read(file))
            section_note = SectionNote.find(section_id: note[:section]) || SectionNote.new(section_id: note[:section])
            section_note.content = note[:content]
            section_note.save
          rescue StandardError => e
            puts "Error loading: #{file}, #{e}"
          end
        end
      end

      desc "Dump Chapter notes"
      task dump_chapter_notes: :environment do
        chatper_notes = ChapterNote.all.each do |chatper_note|
          chapter_file = "db/notes/chapters/#{chatper_note.section_id}_#{chatper_note.chapter_id.to_i}.yaml"
          File.open(chapter_file, 'w') do |out|
            chapter_doc = {
              section: chatper_note.section_id,
              chapter: chatper_note.chapter_id.to_i,
              content: chatper_note.content.force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: '')
            }
            YAML::dump(chapter_doc, out)
          end
        end
      end

      desc "Load Chapter notes into database"
      task chapter_notes: :environment do
        Dir[Rails.root.join('db','notes','chapters','*')].each do |file|
          begin
            note = YAML.load(File.read(file))
            chapter_note = ChapterNote.find(section_id: note[:section],
                                            chapter_id: note[:chapter].to_s) || ChapterNote.new(section_id: note[:section], chapter_id: note[:chapter].to_s)
            chapter_note.content = note[:content]
            chapter_note.save
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
    namespace :updates do
      desc "Remove pending tariff_update entries"
      task pending: :environment do
        Sequel::Model.db.run("DELETE FROM tariff_updates WHERE state = 'P'");
      end
    end

    namespace :taric do
      desc "Remove Sections and Chapter<->Section association records"
      task sections: :environment do
        Section.dataset.delete
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

  namespace :support do
    desc 'Fix CHIEF initial seed last effective dates'

    task fix_chief: :environment do
      Chief::Tame.unprocessed
                 .order(:msrgp_code, :msr_type, :tty_code)
                 .distinct(:msrgp_code, :msr_type, :tty_code)
                 .where(tar_msr_no: nil).each do |ref_tame|
        tames = Chief::Tame.unprocessed
                           .where(msrgp_code: ref_tame.msrgp_code,
                                  msr_type: ref_tame.msr_type,
                                  tty_code: ref_tame.tty_code)
                           .order(Sequel.asc(:fe_tsmp))
                           .all
        blank_tames = tames.select{|tame| tame.le_tsmp.blank? }

        if blank_tames.size > 1
          blank_tames.each do |blank_tame|
            Chief::Tame.filter(blank_tame.pk_hash).update(le_tsmp: tames[tames.index(blank_tame)+1].fe_tsmp) unless blank_tame == tames.last
          end
        end
      end
    end
  end

  namespace :audit do
    desc "Traverse all TARIC tables and perform conformance validations on all the records"
    task verify: [:environment, :class_eager_load] do
      models = (ENV['MODELS']) ? ENV['MODELS'].split(',') : []

      TradeTariffBackend::Auditor.new(models, ENV["SINCE"], ENV["AUDIT_LOG"]).run
    end
  end
end
