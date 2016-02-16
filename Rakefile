#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

if Rails.env.test?
  require 'webmock/rspec'
  WebMock.allow_net_connect!
end

require 'ci/reporter/rake/rspec' if Rails.env.development? or Rails.env.test?

Rails.application.load_tasks
