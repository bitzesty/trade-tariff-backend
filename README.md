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

2. Setup the database:

    ```
    cd UKTradeTariff
    bundle exec rake db:setup
    bundle exec rake db:import
    ```
3. Run UKTradeTariff:

    ```
    ./startup.sh
    ```
