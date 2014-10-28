module GDS
  module SSO
    module Config
      def self.use_mock_strategies?
        ['development', 'test', 'docker'].include?(Rails.env) && ENV['GDS_SSO_STRATEGY'] != 'real'
      end
    end
  end
end
