require 'ostruct'
require "paas_config"

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
      PaasConfig.space
    end

    def govuk_app_name
      ENV["GOVUK_APP_NAME"]
    end

    def production?
      ENV["GOVUK_APP_DOMAIN"] == "tariff-backend-production.cloudapps.digital"
    end

    THREAD_CURRENCY_KEY = :currency

    def currency=(currency)
      Thread.current[THREAD_CURRENCY_KEY] = (currency || "EUR")
    end

    def currency
      Thread.current[THREAD_CURRENCY_KEY] || "EUR"
    end

    def data_migration_path
      File.join(Rails.root, 'db', 'data_migrations')
    end

    def with_redis_lock(lock_name = db_lock_key, &block)
      lock = Redlock::Client.new([ RedisLockDb.redis ])
      lock.lock!(lock_name, 5000, &block)
    end

    def reindex(indexer = search_client)
      TimeMachine.with_relevant_validity_periods do
        begin
          indexer.update
        rescue StandardError => e
          Mailer.reindex_exception(e).deliver_now
        end
      end
    end

    def recache(indexer = cache_client)
      begin
        indexer.update
      rescue StandardError => e
        Mailer.reindex_exception(e).deliver_now
      end
    end

    def pre_warm_headings_cache
      actual_date = Date.yesterday
      TimeMachine.at(actual_date) do
        Heading.dataset.each do |heading|
          ::HeadingService::HeadingSerializationService.new(heading, actual_date).serializable_hash
        end
      end
    end

    def seconds_till_6am
      Time.now.end_of_day + 6.hours - Time.now
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
        indexed_models: indexed_models,
        index_page_size: 500,
        search_operation_options: search_operation_options
      )
    end

    def cache_client
      @cache_client ||= SearchClient.new(
        Elasticsearch::Client.new,
        namespace: 'cache',
        indexed_models: cached_models,
        index_page_size: 5,
        search_operation_options: search_operation_options
      )
    end

    def search_namespace
      @search_namespace ||= 'tariff'
    end
    attr_writer :search_namespace

    # Returns search index instance for given model instance or
    # model class instance
    def search_index_for(namespace, model)
      index_name = model.is_a?(Class) ? model : model.class

      "::#{namespace.capitalize}::#{index_name}Index".constantize.new(search_namespace)
    end

    def search_operation_options
      @search_operation_options || {}
    end
    attr_writer :search_operation_options

    def indexed_models
      [Chapter, Commodity, Heading, SearchReference, Section]
    end

    def cached_models
      [Heading, Certificate, AdditionalCode, Footnote]
    end

    def search_indexes
      indexed_models.map { |model|
        "::Search::#{model}Index".constantize.new(search_namespace)
      }
    end

    def model_serializer_for(namespace, model)
      "::#{namespace.capitalize}::#{model}Serializer".constantize
    end

    def api_version(request)
      request.headers['Accept']&.scan(/application\/vnd.uktt.v(\d+)/)&.flatten&.first || '1'
    end

    def error_serializer(request)
      "Api::V#{api_version(request)}::ErrorSerializationService".constantize.new
    end

    def update_measure_effective_dates
      Sequel::Model.db.run(
        "UPDATE measures_oplog
SET effective_start_date = COALESCE(validity_start_date, r.effective_start_date),
    effective_end_date   = CASE
                               WHEN national THEN validity_end_date
                               WHEN NOT validity_end_date IS NULL AND NOT r.effective_end_date IS NULL THEN LEAST(validity_end_date, r.effective_end_date)
                               WHEN NOT validity_end_date IS NULL AND NOT justification_regulation_id IS NULL AND
                                    NOT justification_regulation_role IS NULL THEN validity_end_date
                               ELSE r.effective_end_date
                           END
FROM (SELECT b.validity_start_date as effective_start_date,
             b.effective_end_date,
             b.base_regulation_id   as regulation_id,
             b.base_regulation_role as regulation_role
      FROM base_regulations b
      UNION ALL
      SELECT m.validity_start_date as effective_start_date,
             m.effective_end_date,
             m.modification_regulation_id   as regulation_id,
             m.modification_regulation_role as regulation_role
      FROM modification_regulations m
     ) as r,
     (SELECT m.oid as operation_id FROM measures m) as m
WHERE oid = m.operation_id
  AND r.regulation_id = measure_generating_regulation_id
  AND r.regulation_role = measure_generating_regulation_role;"
      )
    end
  end
end
