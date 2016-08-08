[![Circle CI](https://circleci.com/gh/bitzesty/trade-tariff-backend.svg?style=svg)](https://circleci.com/gh/bitzesty/trade-tariff-backend)
[![Code Climate](https://codeclimate.com/github/alphagov/trade-tariff-backend/badges/gpa.svg)](https://codeclimate.com/github/alphagov/trade-tariff-backend)

# Trade Tariff Backend

The API back-end for:

* [Trade Tariff Frontend](https://github.com/alphagov/trade-tariff-frontend)
* [Trade Tariff Admin](https://github.com/alphagov/trade-tariff-admin)

Other related projects:

* [Trade Tariff Suite](https://github.com/alphagov/trade-tariff-suite)
* [Trade Tariff Oracle](https://github.com/alphagov/trade-tariff-oracle)

## Development

### Dependencies

  - Ruby
  - Postgresql
  - ElasticSearch
  - Redis
  - Memcached (production)

### Setup

1. Setup your environment.

    bin/setup

2. Update `.env` file with valid data.

3. Start Foreman.

    foreman start

4. Verify that the app is up and running.

    open http://localhost:3018/healthcheck

## Load database

Check out [wiki article on the subject](https://github.com/alphagov/trade-tariff-backend/wiki/System-rebuild-procedure), or get a recent database snapshot.

## Performing daily updates

These are run hourly by a background worker UpdatesSynchronizerWorker.

### Sync process

- checking failures (check tariff_synchronizer.rb) - if any of updates failed in the past, sync process will not proceed
- downloading missing files up to Date.today (check base_update.rb and download methods in taric_update.rb and chief_update.rb)
- applying downloaded files (applying measures, etc. TARIC first, then CHIEF)

Updates are performed in portions and protected by redis lock (see TariffSynchronizer#apply).

BaseUpdate#apply is responsible for most of the logging/checking job and running
`import!` methods located in Taric/ChiefUpdate classes. Then it runs TaricImporter
and ChiefImporter to parse and store xml/csv files.

Whole process is quite similar for both TARIC and CHIEF, but CHIEF updates undergo a tranformation
transformation process to convert them into a TARIC format. Check ChiefTransformer class for more info (and ChiefUpdate#import!).

In case of any errors, changes (per single update) are roll-backed and record itself is marked as failed. The sync would need to be rerun after a rollback.

## Deployment

We deploy to cloud foundry, so you need to have the CLI installed, and the following [cf plugin](https://docs.cloudfoundry.org/cf-cli/use-cli-plugins.html) installed:

Download the plugin for your os:  https://github.com/contraband/autopilot/releases

    chmod +x autopilot-(YOUR_OS)
    cf install-plugin autopilot-(YOUR_OS)

Set the following ENV variables:
* CF_USER
* CF_PASSWORD
* CF_ORG
* CF_SPACE
* CF_APP
* CF_APP_WORKER
* HEALTHCHECK_URL
* SLACK_CHANNEL
* SLACK_WEBHOOK

Then run

    ./bin/deploy

NB: In the newer Diego architecture from CloudFoundry, no-route skips creating and binding a route for the app, but does not specify which type of health check to perform. If your app does not listen on a port, for example the sidekiq worker, then it does not satisfy the port-based health check and Cloud Foundry marks it as crashed. To prevent this, disable the port-based health check with cf set-health-check APP_NAME none.

## Notes

* When writing validators in `app/validators` please run the rake task
`audit:verify` which runs the validator against existing data.

## Contributing

Please check out the [Contributing guide](https://github.com/alphagov/trade-tariff-backend/blob/master/CONTRIBUTING.md)

## Licence

Trade Tariff is licenced under the [MIT licence](https://github.com/alphagov/trade-tariff-backend/blob/master/LICENCE.txt)
