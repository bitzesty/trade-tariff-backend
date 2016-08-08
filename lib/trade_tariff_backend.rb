require 'redis_lock'
require 'ostruct'

module TradeTariffBackend
  autoload :Auditor,         'trade_tariff_backend/auditor'
  autoload :DataMigration,   'trade_tariff_backend/data_migration'
  autoload :DataMigrator,    'trade_tariff_backend/data_migrator'
  autoload :Mailer,          'trade_tariff_backend/mailer'
  autoload :NumberFormatter, 'trade_tariff_backend/number_formatter'
  autoload :SearchClient,    'trade_tariff_backend/search_client'
  autoload :Validator,       'trade_tariff_backend/validator'

  class << self
    def configure
      yield self
    end

    # Lock key used for DB locks to keep just one instance of synchronizer
    # running in cluster environment
    def db_lock_key
      'tariff-lock'
    end

    def log_formatter
      Proc.new {|severity, time, progname, msg| "#{time.strftime('%Y-%m-%dT%H:%M:%S.%L %z')} #{sprintf('%5s', severity)} #{msg}\n" }
    end

    # Email of the user who receives all info/error notifications
    def from_email
      ENV.fetch("TARIFF_FROM_EMAIL")
    end

    # Email of the user who receives all info/error notifications
    def admin_email
      ENV.fetch("TARIFF_SYNC_EMAIL")
    end

    def platform
      Rails.env
    end

    def deployed_environment
      MAILER_ENV
    end

    def govuk_app_name
      ENV["GOVUK_APP_NAME"]
    end

    def data_migration_path
      File.join(Rails.root, 'db', 'data_migrations')
    end

    def with_redis_lock(lock_name = db_lock_key, &block)
      lock = RedisLock.new(RedisLockDb.redis, lock_name)
      lock.lock &block
    end

    def reindex(indexer = search_client)
      TimeMachine.with_relevant_validity_periods do
        begin
          indexer.reindex
        rescue StandardError => e
          Mailer.reindex_exception(e).deliver_now
        end
      end
    end

    # Number of changes to fetch for Commodity/Heading/Chapter
    def change_count
      10
    end

    def number_formatter
      @number_formatter ||= TradeTariffBackend::NumberFormatter.new
    end

    def search_client
      @search_client ||= SearchClient.new(
        Elasticsearch::Client.new,
        namespace: search_namespace,
        indexed_models: indexed_models,
        search_operation_options: search_operation_options
      )
    end

    def search_namespace
      @search_namespace ||= 'tariff'
    end
    attr_writer :search_namespace

    # Returns search index instance for given model instance or
    # model class instance
    def search_index_for(model)
      index_name = model.is_a?(Class) ? model : model.class

      "#{index_name}Index".constantize.new(search_namespace)
    end

    def search_operation_options
      @search_operation_options || {}
    end
    attr_writer :search_operation_options

    def indexed_models
      [Chapter, Commodity, Heading, SearchReference, Section]
    end

    def search_indexes
      indexed_models.map { |model|
        "#{model}Index".constantize.new(search_namespace)
      }
    end

    def model_serializer_for(model)
      "#{model}Serializer".constantize
    end
  end
end
