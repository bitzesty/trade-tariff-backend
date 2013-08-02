TradeTariffBackend::DataMigrator.reporter = TradeTariffBackend::DataMigrator::ConsoleReporter

namespace :db do
  namespace :data do
    desc "Applies all pending data migrations"
    task migrate: :environment do
      TradeTariffBackend::DataMigrator.migrate
    end

    desc "Rollsback last applied data migration"
    task rollback: :environment do
      TradeTariffBackend::DataMigrator.rollback
    end

    desc "Prints data migration application status"
    task status: :environment do
      TradeTariffBackend::DataMigrator.status
    end

    desc "Rollsback last data migration and reapplies it"
    task redo: :environment do
      TradeTariffBackend::DataMigrator.redo
    end
  end
end
