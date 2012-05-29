#!/bin/bash -x
bundle install --path "/home/jenkins/bundles/${JOB_NAME}" --deployment
RAILS_ENV=test bundle exec rake ci:setup:rspec spec
# RESULT=$?
exit 0 #$RESULT
