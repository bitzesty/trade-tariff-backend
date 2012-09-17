#!/bin/bash -x
bundle install --path "/home/jenkins/bundles/${JOB_NAME}" --deployment

RAILS_ENV=test bundle exec rake db:force_close_open_connections
RAILS_ENV=test bundle exec rake db:reset

RAILS_ENV=test bundle exec rake db:schema_load
RAILS_ENV=test bundle exec rake ci:setup:rspec spec
RESULT=$?
exit $RESULT
