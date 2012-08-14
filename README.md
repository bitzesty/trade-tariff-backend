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

1. Create database

    ```
    bundle exec rake db:create
    ```

2. Load database snapshot or perform importing

2.1. Import EU TARIC files

Download and extract the TARIC snapshot files from the 5th Jun 2012 from 
https://github.com/downloads/alphagov/trade-tariff-backend/taric-initial-load.tar.gz
to the tmp folder then run the following commands:

    bundle exec rake db:migrate

    bundle exec rake importer:taric:import TARGET=tmp/OBEXTACTEN.xml
    
    bundle exec rake importer:taric:import TARGET=tmp/OBEXTACT.xml
    
2.2. Download the db snapshot (TODO)

3. Load Sections, Section notes, Chapter notes and other tariff data

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

* Instructions on how to run the CHIEF importers
* Timezone config