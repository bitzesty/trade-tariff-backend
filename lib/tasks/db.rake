namespace :db do
  desc "Import XLS data"
  task import: 'environment' do
    load(File.join(Rails.root, 'db', 'import.rb'))
  end
end
