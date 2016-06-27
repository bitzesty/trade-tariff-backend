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

  - Ruby 2.2.3
  - Postgresql
  - ElasticSearch
  - Redis

### Setup

1. Setup your environment.

        % bin/setup

2. Update `.env` file with valid data.

        % vim .env

3. Start Foreman.

        % foreman start

4. Verify that the app is up and running.

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

## Deployment

We use manifest files to deploy manually to CloudFoundry, but these are not in the repository since they have reference of environment variables that may hold sensitive information.

Make sure to be on the right organization and space:

    cf target -o "trade-tariff" -s "staging"

Make sure the services that the app depends are available in the marketplace:

    cf create-service <service> <service-plan> <new-service-name>

If it's the first time the app is deployed, from the root folder of the app:

    cf push <app-name-we-desired>

If the app is already created we can create a manifest file with this command:

    cf create-app-manifest tariff-backend-staging

And deploy with the new manifest file with:

    cf push -f tariff-backend-worker-staging_manifest.yml

In the newer Diego architecture from CloudFoundry, no-route skips creating and binding a route for the app, but does not specify which type of health check to perform. If your app does not listen on a port, for example the sidekiq worker, then it does not satisfy the port-based health check and Cloud Foundry marks it as crashed. To prevent this, disable the port-based health check with cf set-health-check APP_NAME none.

## Notes

* When writing validators in `app/validators` please run the rake task
`audit:verify` which runs the validator against existing data.

## Contributing

Please check out the [Contributing guide](https://github.com/alphagov/trade-tariff-backend/blob/master/CONTRIBUTING.md)

## Licence

Trade Tariff is licenced under the [MIT licence](https://github.com/alphagov/trade-tariff-backend/blob/master/LICENCE.txt)
