#!/bin/bash
export RAILS_ENV=docker
bundle install
bundle exec whenever --update-crontab
bundle exec foreman start
exit 0
