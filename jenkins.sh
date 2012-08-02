#!/bin/bash -x
bundle install --path "/home/jenkins/bundles/${JOB_NAME}" --deployment
RAILS_ENV=test bundle exec rake db:drop --trace
RAILS_ENV=test bundle exec rake db:create --trace
RAILS_ENV=test bundle exec rake db:schema:load --trace
RAILS_ENV=test bundle exec rake ci:setup:rspec spec
RESULT=$?
exit $RESULT
