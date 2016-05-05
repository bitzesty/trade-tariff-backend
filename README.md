[![Circle CI](https://circleci.com/gh/bitzesty/trade-tariff-backend.svg?style=svg)](https://circleci.com/gh/bitzesty/trade-tariff-backend)
[![Code Climate](https://codeclimate.com/github/alphagov/trade-tariff-backend/badges/gpa.svg)](https://codeclimate.com/github/alphagov/trade-tariff-backend)

# Trade Tariff Backend

The API back-end for:

* [Trade Tariff Frontend](https://github.com/alphagov/trade-tariff-frontend)
* [Trade Tariff Admin](https://github.com/alphagov/trade-tariff-admin)

Also uses:

* [Trade Tariff Suite](https://github.com/alphagov/trade-tariff-suite)
* [Trade Tariff Oracle](https://github.com/alphagov/trade-tariff-oracle)

## Development

### Dependencies

  - ElasticSearch
  - Postgresql
  - Redis
  - Ruby 2.2.3

### Setup

1. Get the code.

        % git clone git@github.com:alphagov/trade-tariff-backend.git

2. Setup your environment.

        % bin/setup

3. Update `.env` file with valid data.

        % vim .env

4. Start Foreman.

        % foreman start

5. Verify that the app is up and running.

        % open http://localhost:3018/healthcheck

## Load database

Check out [wiki article on the subject](https://github.com/alphagov/trade-tariff-backend/wiki/System-rebuild-procedure), or get a recent database snapshot.

## Performing daily updates

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

* When writing validators in `app/validators` please run the rake task
`audit:verify` which runs the validator against existing data.

## Contributing

Please check out the [Contributing guide](https://github.com/alphagov/trade-tariff-backend/blob/master/CONTRIBUTING.md)

## Licence

Trade Tariff is licenced under the [MIT licence](https://github.com/alphagov/trade-tariff-backend/blob/master/LICENCE.txt)
