#!/bin/bash -x
bundle install --path "/home/jenkins/bundles/${JOB_NAME}" --deployment
RAILS_ENV=test bundle exec rake db:drop
RAILS_ENV=test bundle exec rake db:schema:load
RAILS_ENV=test bundle exec rake ci:setup:rspec spec
RESULT=$?
exit $RESULT
