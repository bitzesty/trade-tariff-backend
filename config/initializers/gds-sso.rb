GDS::SSO.config do |config|
  config.user_model   = "User"
  config.oauth_id     = ENV['TRADE_TARIFF_OAUTH_ID'] || "abcdefgh12345678pan"
  config.oauth_secret = ENV['TRADE_TARIFF_OAUTH_SECRET'] || "secret"
  config.oauth_root_url = Plek.current.find("signon")
  config.basic_auth_user = ENV['TRADE_TARIFF_USER'] || "api"
  config.basic_auth_password = ENV['TRADE_TARIFF_PASSWORD'] || "defined_on_rollout_not"
end
