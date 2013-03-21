
[![Build Status](https://travis-ci.org/alphagov/trade-tariff-backend.png?branch=master)](https://travis-ci.org/alphagov/trade-tariff-backend)

# TradeTariffBackend

The API backend for TradeTariffFrontend application

## If using gov.uk development puppet repo

Ensure that you have pulled the latest version of the development repo.
Run the bootstrap command.

## Dependencies (OS X using Homebrew)

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
    bundle exec rake tariff:sync:apply
    ```

## Notes

* Project does not contain schema.rb, do not use rake db:schema:load. Sequel
does not yet support view creation via schema file.

## TODO

* Timezone config
