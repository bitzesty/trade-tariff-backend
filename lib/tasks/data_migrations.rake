namespace :db do
  namespace :data do
    desc "Applies all pending data migrations"
    task migrate: :environment do
      TradeTariffBackend::DataMigrator.reporter = TradeTariffBackend::DataMigrator::ConsoleReporter

      TradeTariffBackend::DataMigrator.migrate
    end

    desc "Rollsback last applied data migration"
    task rollback: :environment do
      TradeTariffBackend::DataMigrator.reporter = TradeTariffBackend::DataMigrator::ConsoleReporter

      TradeTariffBackend::DataMigrator.rollback
    end

    desc "Prints data migration application status"
    task status: :environment do
      TradeTariffBackend::DataMigrator.reporter = TradeTariffBackend::DataMigrator::ConsoleReporter

      TradeTariffBackend::DataMigrator.status
    end
  end
end
