# UK Trade Tariff

The API backend for UK Trade Tariff Web application.

## Dependencies (OS X using Homebrew)

1. ElasticSearch

    ```
    brew install elasticsearch
    ```
2. MySQL

    ```
    brew install mysql
    ```

3. Ruby 1.9.3

## If using gov.uk development puppet repo

Ensure that you have pulled the latest version of the development repo.
Run the bootstrap command.

## Setup UKTradeTariff

1. Load sections

    ```
    bundle exec rake db:import
    ```

2. Load database snapshot (TariffImporter). TBD

3. Index on ElasticSearch

    ```
    bundle exec rake environment tire:import CLASS='Section'
    bundle exec rake environment tire:import CLASS='Chapter'
    bundle exec rake environment tire:import CLASS='Heading'
    bundle exec rake environment tire:import CLASS='Commodity'
    ```

## Run UKTradeTariff

    ./startup.sh

## TODO

* Instructions on how to run the TARIC and CHIEF importers
* How to load pre imported db dumps.
* Rewrite all the mongoid specs to sequel.
* Timezone config
* Background tasks for daily import