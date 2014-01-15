require 'ostruct'

module TradeTariffBackend
  autoload :Auditor,         'trade_tariff_backend/auditor'
  autoload :DataMigration,   'trade_tariff_backend/data_migration'
  autoload :DataMigrator,    'trade_tariff_backend/data_migrator'
  autoload :Indexer,         'trade_tariff_backend/indexer'
  autoload :Mailer,          'trade_tariff_backend/mailer'
  autoload :NumberFormatter, 'trade_tariff_backend/number_formatter'
  autoload :SearchClient,    'trade_tariff_backend/search_client'
  autoload :SearchIndex,     'trade_tariff_backend/search_index'
  autoload :Validator,       'trade_tariff_backend/validator'

  class << self

    # Lock key used for DB locks to keep just one instance of synchronizer
    # running in cluster environment
    def db_lock_key
      'tariff-lock'
    end

    def log_formatter
      Proc.new {|severity, time, progname, msg| "#{time.strftime('%Y-%m-%dT%H:%M:%S.%L %z')} #{sprintf('%5s', severity)} #{msg}\n" }
    end

    # Email of the user who receives all info/error notifications
    def admin_email
      secrets.sync_email || 'trade-tariff-alerts@digital.cabinet-office.gov.uk'
    end

    def platform
      ENV["FACTER_govuk_platform"] || Rails.env
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

    def with_locked_database(&block)
      # We should use the master database for this
      Sequel::Model.db.with_server(:default) do
        begin
          if Sequel::Model.db.get_lock(db_lock_key)
            yield
          end
        ensure
          Sequel::Model.db.release_lock(db_lock_key)
        end
      end
    end

    def with_redis_lock(lock_name = db_lock_key, &block)
      Sidekiq.redis do |redis_namespace|
        redis_namespace.redis.lock(lock_name, life: 30.minutes) do
          yield
        end
      end
    end

    def reindex(indexer = Indexer)
      begin
        indexer.run
      rescue StandardError => e
        Mailer.reindex_exception(e).deliver
      end
    end

    def secrets
      @secrets ||= OpenStruct.new(load_secrets)
    end

    # Number of changes to fetch for Commodity/Heading/Chapter
    def change_count
      10
    end

    def search_index
      SearchIndex
    end

    def number_formatter
      @number_formatter ||= TradeTariffBackend::NumberFormatter.new
    end

    def search_client
      @search_client = SearchClient.new(
        Elasticsearch::Client.new(
          host: search_host,
          log: true
        ),
        namespace: search_namespace,
        indexed_models: indexed_models
      )
    end

    def search_host
      'http://localhost:9200'
    end

    def search_namespace
      'tariff'
    end

    def indexed_models
      [Chapter, Commodity, Heading, SearchReference, Section]
    end

    def model_serializer_for(model)
      "#{model}Serializer".constantize
    end

    private

    def load_secrets
      if File.exists?(secrets_path)
        YAML.load_file(secrets_path)
      else
        {}
      end
    end

    def secrets_path
      File.join(Rails.root, 'config', 'trade_tariff_backend_secrets.yml')
    end
  end
end
