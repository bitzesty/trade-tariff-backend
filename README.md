# UKTariffWebApp

An API back end for UK Trade Tariff web app.

## Dependencies

1. ElasticSearch (Mac OS X using Homebrew):

    ```
    brew install elasticsearch
    ```

## Local install/run instructions

1. Install repo (see http://source.android.com/source/downloading.html#installing-repo):
    
    ```
    brew intall repo 
    ```

2. Run repo commands

    ```
    mkdir gds-tariff
    cd gds-tariff
    repo init -u git@github.com:alphagov/UKTradeTariff.git -b manifest
    repo sync
    ```

2. Setup the database and perform scraping: see instructions over here https://github.com/alphagov/TariffScraper.

3. Run UKTradeTariff:

    ```
    ./startup.sh
    ```

Useful commands:

* Drop index

    ```
    bundle exec rake tire:index:drop INDEX='commodities'
    ```

* Reindex

    ```
    bundle exec rake environment tire:import CLASS='Commodity'
    ```
