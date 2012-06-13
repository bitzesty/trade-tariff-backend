# UKTariffWebApp

An API back end for UK Trade Tariff web app.

## Dependencies

1. ElasticSearch (Mac OS X using Homebrew):

    ```
    brew install elasticsearch
    ```
2. MongoDB

    ```
    brew install mongodb
    ```

## Local install/run instructions

1. Install repo see http://source.android.com/source/downloading.html#installing-repo :

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

3. Setup the database

    Then perform scraping see instructions over here https://github.com/alphagov/TariffScraper or load a pre scraped mongodb dump.

    ```
    rake db:mongoid:create_indexes

    rake db:update_duties_cache
    ````

4. Run UKTradeTariff:

    ```
    ./startup.sh
    ```

Useful commands:

* Sync all repos

    ```
    repo sync
    ```
