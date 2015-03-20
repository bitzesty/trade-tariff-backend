TradeTariffBackend::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  config.eager_load = false

  # This is required for Plek 1.x, but we don't want to have to set it
  # when running the tests.
  if ENV['GOVUK_APP_DOMAIN'].blank?
    ENV['GOVUK_APP_DOMAIN'] = 'test.gov.uk'
  end

  config.after_initialize do
    TradeTariffBackend.configure do |tariff|
      tariff.search_namespace = 'tariff-test' # default is just tariff
      tariff.search_options = {
        log: false
      }
      # We need search index to be refreshed after each operation
      # in order to assert record presence in the index (in integration specs)
      # Elasticsearch has a 1 second interval between index refreshes
      # by default.
      tariff.search_operation_options = { refresh: true }
    end
  end
end
