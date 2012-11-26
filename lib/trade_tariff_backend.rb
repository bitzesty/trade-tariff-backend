require 'ostruct'

module TradeTariffBackend
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
      secrets.sync_email
    end

    def with_locked_database(&block)
      begin
        if Sequel::Model.db.get_lock(db_lock_key)
          yield
        end
      ensure
        Sequel::Model.db.release_lock(db_lock_key)
      end
    end

    def secrets
      @secrets ||= OpenStruct.new(load_secrets)
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
