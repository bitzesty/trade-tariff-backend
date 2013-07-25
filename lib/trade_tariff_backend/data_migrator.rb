require 'singleton'
require 'forwardable'

module TradeTariffBackend
  class DataMigrator
    include Singleton
    extend SingleForwardable

    def_delegators :instance, :migrations, :migrations=, :migrate, :migration, :rollback

    attr_writer :migrations

    # Define a new migration
    def migration(&block)
      @migrations ||= []

      TradeTariffBackend::DataMigration.new(&block).tap { |migration|
        @migrations << migration
      }
    end

    # List of available migrations
    def migrations
      @migrations || []
    end

    # Migrates all pending migrations
    def migrate
      migrations.select(&:can_rollup?).each { |migration|
        migration.up.apply
      }
    end

    # Rollsback last applied migration
    def rollback
      migrations.select(&:can_rolldown?).last.tap { |migration|
        migration.down.apply
      }
    end
  end
end
