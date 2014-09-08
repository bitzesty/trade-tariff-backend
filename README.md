[![Build Status](https://travis-ci.org/alphagov/trade-tariff-backend.png?branch=master)](https://travis-ci.org/alphagov/trade-tariff-backend)

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

### Manual Rollback

  ```
  DATE='2014-01-30' bundle exec rake tariff:sync:rollback
  ```

## Development with Docker and Fig

### Fig / Docker setup

#### 1. Install docker and fig
   Check out [Install Guide](http://www.fig.sh/install.html)

#### 2. Build fig in app root.
   ##### NOTE: you also need to setup frontend and admin apps with docker before.
   * [Trade Tariff Frontend](https://github.com/alphagov/trade-tariff-frontend)
   * [Trade Tariff Admin](https://github.com/alphagov/trade-tariff-admin)

   ##### NOTE: can take some time to download and build some docker images

   ```
   fig build && fig up -d && chmod -x docker_ips.sh && sudo bash docker_ips.sh

   # NOTE: it's important to run 'sudo bash docker_ips.sh', because IPs of docker containers are dynamic
   # and will be changed anytime you run 'fig start' or 'fig up'
   ```

#### 3. Prepare database in api docker containers:
   ```
   fig run api bundle exec db:create db:migrate db:seed
   ```

#### 4. Now you can open in browser:
   ##### [API Root](http://tariff-api.dev.gov.uk:3018)
   ##### [FRONTEND Root](http://tariff.dev.gov.uk:3017)
   ##### [ADMIN Root](http://tariff-admin.dev.gov.uk:3046)

### Development via Docker / Fig

#### Deploy latest version of app to docker / fig container

   NOTE: it's important to pass '--no-recreate' option for 'fig up' command.
         By default 'fig up' will recreate all environment (including database)

   ```
   fig stop && fig up -d --no-recreate && sudo bash docker_ips.sh
   ```

#### Start / stop server

   ```
   fig stop
   fig start && sudo bash docker_ips.sh
   ```

#### Run db migrations / rake tasks

   ```
   fig run api bundle exec rake db:migrate
   ```

#### Rails console

   ```
   fig run api bundle exec rails console
   ```

#### View app logs

   ```
   fig logs api
   ```

#### Run Rspec tests

   ```
   fig run api bundle exec rake spec
   ```

#### SSH to docker app
 
   ```
   $ fig run api /bin/sh
   root@af8bae53bdd3:/#

   # when you're done you can use the exit command to finish.
   # root@af8bae53bdd3:/# exit
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
