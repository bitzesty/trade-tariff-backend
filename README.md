
[![Build Status](https://travis-ci.org/alphagov/trade-tariff-backend.png?branch=master)](https://travis-ci.org/alphagov/trade-tariff-backend)

# TradeTariffBackend

The API back-end for:

* TradeTariffFrontend application
* TradeTariffAdmin application

## Setup

### If using the GOV.UK development Vagrant VM

Ensure that you have pulled the latest version of the puppet repo.

Run the bootstrap command `govuk_puppet`.

### Dependencies (OS X using Homebrew)

1. ElasticSearch & MySQL

    ```
    brew install elasticsearch
    brew install mysql
    ```

2. Ruby 1.9.3

## Setup TradeTariffBackend

Check out [wiki article on the subject](https://github.com/alphagov/trade-tariff-backend/wiki/System-rebuild-procedure).

## Run TradeTariffBackend

    ./startup.sh

## Performing daily updates

1. Create config/trade_tariff_backend_secrets.yml file with correct values.

  ```yaml
  sync_username:
  sync_password:
  sync_host:
  sync_email:
  ```

2. Apply updates

  ```
  govuk_setenv tariff-api bundle exec rake tariff:sync:apply
  ```

## Manual Rollback

  ```
  DATE='2014-01-30' REDOWNLOAD=1 govuk_setenv tariff-api bundle exec rake tariff:sync:rollback
  ```

## Notes

* Project does __not__ contain schema.rb, do not use rake db:schema:load. Sequel
does not yet support view creation via schema file.

## TODO

* Timezone config
