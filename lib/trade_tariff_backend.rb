require 'ostruct'

module TradeTariffBackend
  class << self
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
