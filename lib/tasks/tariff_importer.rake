require 'tariff_importer'

# Import CHIEF or Taric file manually. Usually needed to import initial
# seed files.

namespace :importer do
  namespace :chief do
    desc "Import CHIEF file"
    task import: :environment do

      if ENV["TARGET"] && File.exists?(ENV["TARGET"])
        TariffImporter.import(Pathname.new(ENV["TARGET"]), ChiefImporter).import
      else
        puts "Please provide TARGET environment variable pointing to CHIEF file to import"
      end
    end
  end

  namespace :taric do
    desc "Import Tariff file"
    task import: :environment do
      if ENV["TARGET"] && File.exists?(ENV["TARGET"])
        TariffImporter.import(Pathname.new(ENV["TARGET"]), TaricImporter).import
      else
        puts "Please provide TARGET environment variable pointing to Tariff file to import"
      end
    end
  end
end
