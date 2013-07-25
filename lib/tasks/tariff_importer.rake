require 'tariff_importer'

# Import CHIEF or Taric file manually. Usually needed to import initial
# seed files.

namespace :importer do
  namespace :chief do
    desc "Import CHIEF file"
    task import: :environment do

      if ENV["TARGET"] && File.exists?(ENV["TARGET"])
        ChiefImporter.new(ENV["TARGET"], ENV["DATE"]).import
      else
        puts "Please provide TARGET environment variable pointing to CHIEF file to import"
      end
    end
  end

  namespace :taric do
    desc "Import Tariff file"
    task import: [:environment, :class_eager_load] do
      if ENV["TARGET"] && File.exists?(ENV["TARGET"])
        # We will be fetching updates from Taric and modifying primary keys
        # so unrestrict it for all models.
        Sequel::Model.descendants.each(&:unrestrict_primary_key)

        TaricImporter.new(ENV["TARGET"], ENV["DATE"]).import
      else
        puts "Please provide TARGET environment variable pointing to Tariff file to import"
      end
    end
  end
end
