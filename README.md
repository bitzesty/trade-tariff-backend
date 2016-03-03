[![Circle CI](https://circleci.com/gh/bitzesty/trade-tariff-backend.svg?style=svg)](https://circleci.com/gh/bitzesty/trade-tariff-backend)
[![Code Climate](https://codeclimate.com/github/alphagov/trade-tariff-backend/badges/gpa.svg)](https://codeclimate.com/github/alphagov/trade-tariff-backend)

# Trade Tariff Backend

The API back-end for:

* [Trade Tariff Frontend](https://github.com/alphagov/trade-tariff-frontend)
* [Trade Tariff Admin](https://github.com/alphagov/trade-tariff-admin)

Also uses:

* [Trade Tariff Suite](https://github.com/alphagov/trade-tariff-suite)
* [Trade Tariff Oracle](https://github.com/alphagov/trade-tariff-oracle)

## Setup

### If using the GOV.UK development Vagrant VM

Ensure that you have pulled the latest version of the puppet repo.

Run the bootstrap command `govuk_puppet`.

### Dependencies (OS X using Homebrew)

1. ElasticSearch & MySQL & Redis

    ```
    brew install elasticsearch
    brew install redis
    brew install mysql
    ```

2. Ruby 2.0.0

    ```
    brew install chruby
    brew install ruby-install
    ```

## Load database

Check out [wiki article on the subject](https://github.com/alphagov/trade-tariff-backend/wiki/System-rebuild-procedure), or get a recent database snapshot.

### Load database seeds for development API user

  ```
  bundle exec rake db:seed
  ```

## Run Backend

  ```
  bundle exec ./startup.sh
  ```

## Performing daily updates

1. Create config/trade_tariff_backend_secrets.yml file with correct values.

  ```yaml
  sync_username:
  sync_password:
  sync_host:
  sync_email:
  ```

2. Run the sync rake task

  ```
  bundle exec rake tariff:sync:apply
  ```

### Sync process

- checking failures (check tariff_synchronizer.rb) - if any of updates failed in the past, sync process will not proceed
- downloading missing files up to Date.today (check base_update.rb and download methods in taric_update.rb and chief_update.rb)
- applying downloaded files (applying measures, etc. TARIC first, then CHIEF)

Applying downloaded CSV files is the most confusing and buggy part.
Updates are performed in portions and protected by redis lock (see TariffSynchronizer#apply).

BaseUpdate#apply is responsible for most of the logging/checking job and running
`import!` methods located in Taric/ChiefUpdate classes. Then it runs TaricImporter
and ChiefImporter to parse and store xml/csv files.

Whole process is quite similar for both TARIC and CHIEF, but CHIEF updates also does
transformation process at the end. Check ChiefTransformer class for more info (and ChiefUpdate#import!).

In case of any errors, changes (per single update) are roll-backed and record itself is marked as failed.

### Manual Rollback

  Keep in mind that there are two ways of rolling-back, one with keeping the intermediary updates stored in db, and another one without.
  The default option is to remove TARIC/CHIEF updates and data transformations.

  ```
  DATE='2014-01-30' bundle exec rake tariff:sync:rollback
  ```

## Notes

* Project does __not__ contain schema.rb, do not use rake db:schema:load. Sequel
does not yet support view creation via schema file.

* When writing validators in `app/validators` please run the rake task
`audit:verify` which runs the validator against existing data.

## Contributing

Please check out the [Contributing guide](https://github.com/alphagov/trade-tariff-backend/blob/master/CONTRIBUTING.md)

## Licence

Trade Tariff is licenced under the [MIT licence](https://github.com/alphagov/trade-tariff-backend/blob/master/LICENCE.txt)
