# TODO: This file probably doesn't have a reason to exist

require 'router'
require 'logger'

namespace :router do
  task :router_environment => :environment do
    @logger = Logger.new STDOUT
    @logger.level = Logger::DEBUG
    @router = Router.new("http://router.cluster:8080/router", @logger)
    @slug = "tariff-api"
  end

  task :register_application => :router_environment do
    platform = ENV['FACTER_govuk_platform']
    url = "#{@slug}.#{platform}.alphagov.co.uk"
    @logger.info "Registering application..."
    @router.update_application @slug, url
  end

  task :register_routes => :router_environment do
    @router.create_route @slug, "prefix", @slug
  end

  desc "Register tariff-api application and routes with the router (run this task on server in cluster)"
  task :register => [ :register_application, :register_routes ]
end
