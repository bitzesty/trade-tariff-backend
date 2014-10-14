#!/bin/bash
bundle install
bundle exec whenever --update-crontab
bundle exec unicorn -p 3018
exit 0
