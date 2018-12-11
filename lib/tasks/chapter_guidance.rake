namespace :chapters do
  desc "Import guidance for chapters"
  task import_guidances: :environment do
    load(File.join(Rails.root, 'db', 'import_chapter_guidances.rb'))
  end
end
