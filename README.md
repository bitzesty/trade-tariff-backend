# UKTariffWebApp

An API back end for UK Trade Tariff web app.

## Dependencies

1. ElasticSearch (Mac OS X using Homebrew):

    ```
    brew install elasticsearch
    ```

## Local install/run instructions

1. Clone repo:

    ```
    git clone git@github.com:alphagov/UKTradeTariff.git
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
