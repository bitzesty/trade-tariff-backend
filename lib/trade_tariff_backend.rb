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
    def admin_email
      secrets.sync_email || 'trade-tariff-alerts@digital.cabinet-office.gov.uk'
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
      Redis::Mutex.with_lock(lock_name, expire: 10.minutes) { yield }
    end

    def reindex(indexer = search_client)
      TimeMachine.with_relevant_validity_periods do
        begin
          indexer.reindex
        rescue StandardError => e
          Mailer.reindex_exception(e).deliver
        end
      end
    end

    def secrets
      @secrets ||= OpenStruct.new(load_secrets)
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
        Elasticsearch::Client.new(search_options),
        namespace: search_namespace,
        indexed_models: indexed_models,
        search_operation_options: search_operation_options
      )
    end

    def search_host
      @search_host ||= if ENV["ELASTICSEARCH_1_PORT_9200_TCP"].present?
        "http://#{ENV["ELASTICSEARCH_1_PORT_9200_TCP_ADDR"]}:#{ENV["ELASTICSEARCH_1_PORT_9200_TCP_PORT"]}"
      else
        "http://localhost:#{search_port}"
      end
    end
    attr_writer :search_host

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

    def search_port
      @search_port ||= 9200
    end
    attr_writer :search_port

    def default_search_options
      { host: search_host, logger: Rails.logger }
    end

    def search_options
      default_search_options.merge(@search_options || {})
    end
    attr_writer :search_options

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
