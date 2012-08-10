namespace :tariff do
  desc 'Installs Trade Tariff, creates relevant records, imports national data'
  task install: %w[environment
                   install:taric:sections]

  namespace :install do
    namespace :taric do
      desc "Add Sections and associate to Chapters"
      task sections: :environment do
        load(File.join(Rails.root, 'db', 'import_sections.rb'))
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
