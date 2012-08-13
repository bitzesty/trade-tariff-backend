# TradeTariffBackend

The API backend for TradeTariffFrontend application.

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

## Setup TradeTariffBackend

1. Create database.

    ```
    bundle exec rake db:create
    ```

2. Load database snapshot (TariffImporter). Or perform importing. TBD

3. Load Sections, Section notes, Chapter notes and other tariff data.

    ```
    bundle exec rake tariff:install
    ```

4. Index on ElasticSearch

    ```
    bundle exec rake tariff:reindex
    ```

## Run TradeTariffBackend

    ./startup.sh

## TODO

* Instructions on how to run the TARIC and CHIEF importers
* How to load pre-imported db dumps.
* Timezone config
* Background tasks for daily import
