namespace :chapters do
  desc "Import guides for chapters and populate m-t-m association table"
  task create_guides: :environment do
    load(File.join(Rails.root, 'db', 'import_chapter_guides.rb'))
  end
end
