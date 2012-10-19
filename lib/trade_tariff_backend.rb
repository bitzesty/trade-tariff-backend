require 'ostruct'

module TradeTariffBackend
  class << self

    # Lock key used for DB locks to keep just one instance of synchronizer
    # running in cluster environment
    def db_lock_key
      'tariff-lock'
    end

    def with_locked_database(&block)
      begin
        if Sequel::Model.db.get_lock(db_lock_key)
          yield
        else
          logger.error "Could not acquire db lock, process is being execued by other node."
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
