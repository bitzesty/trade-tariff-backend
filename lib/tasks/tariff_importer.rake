namespace :importer do
  namespace :chief do
    desc "Import CHIEF file"
    task :import => :environment do
      require 'tariff_importer'

      if ENV["TARGET"] && File.exists?(ENV["TARGET"])
        TariffImporter.new(ENV["TARGET"], ChiefImporter).import
      else
        puts "Please provide TARGET environment variable pointing to CHIEF file to import"
      end
    end

    desc "Transform Chief data into taric and save"
    task :transform => :environment do
      require 'chief_transformer'
      ChiefTransformer.instance.invoke
    end
  end

  namespace :taric do
    desc "Import Tariff file"
    task :import => :environment do
      require 'tariff_importer'

      if ENV["TARGET"] && File.exists?(ENV["TARGET"])
        TariffImporter.new(ENV["TARGET"], TaricImporter).import
      else
        puts "Please provide TARGET environment variable pointing to Tariff file to import"
      end
    end
  end
end
