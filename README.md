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

1. Load sections

    ```
    bundle exec rake db:import_sections
    ```

2. Load Section notes

    ```
    bundle exec rake db:section_notes
    ```

3. Load Chapter notes

    ```
    bundle exec rake db:chapter_notes
    ```

4. Load database snapshot (TariffImporter). TBD

5. Index on ElasticSearch

    ```
    RAILS_ENV=production bundle exec rake tariff:reindex
    ```

## Run TradeTariffBackend

    ./startup.sh

## TODO

* Instructions on how to run the TARIC and CHIEF importers
* How to load pre-imported db dumps.
* Timezone config
* Background tasks for daily import
