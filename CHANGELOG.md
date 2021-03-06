# Change Log

## [December 24, 2020](https://github.com/bitzesty/trade-tariff-backend/compare/9badbe2622e12b784e796afb35e49dd9d4352571...5e6ed767fb2de28e86d5f55787142fae605b009d)

### Added
- CDS update type and environment
- Add PaaS autoscaling policy
- Add measure_condition_components to api v2 response
- Log filename for cds data records
- Data migrations

### Changed
- Text formatting for regulations
- Update support email address
- Using `insert` instead of `save` in cds mapper
- Fix quota_definition<->measure relation
- Update puma to 5.0.4
- Upgrade ruby buildpack
- Replace `fast_jsonapi` with `jsonapi-serializer` gem

### Removed
- Remove rails (redis) caching
- Skip old data migrations on cds env


## [August 04, 2020](https://github.com/bitzesty/trade-tariff-backend/compare/b9d1803faff907f7dfbc86c25dc53fd01ca6678e...59bfeb5f4d17964e68546fdd6cb23aaa235ff662)

### Added
- Add CAS numbers (chemical names mapped to goods nomenclatures)
- Add TARIC sequence checker
- Several data migrations
- Serialize `productline_suffix` for goods nomenclature in API v2
- Add env name to pdf emails subject

### Changed
- Measure components ordering on database level
- UKTT gem updates
- Upgrade to ruby 2.7.1
- Upgrade rails to 6.0.3.2
- Upgrade puma to 3.12.6
- Upgrade sidekiq to v6
- Update generated pdf links
- Fix additional code description order by validity start date
- Render proper suspension legal act in measures serializer for API v2
- Update CF buildpack

### Removed
- Remove rails_12factor gem
- Disable commodity serializer caching
- Skip health check url for scout_apm


## [Dec 27, 2019](https://github.com/bitzesty/trade-tariff-backend/compare/38031efc8c2d07cb3de76d9333348c3fa09561ce...5fe1ca944485eb45b89bf154c0c272459af40a5c)

### Added
- Produce PDF in multiple currencies
- Add footnotes search endpoint to API v2
- Add footnotes type endpoint to API v2
- Add additional code type endpoint to API v2
- Add certificate type endpoint to API v2
- Add pagination to search endpoints
- Add measure components to API v2 response
- Add `measures` relation to additional code and certificate

### Changed
- Change "additional_code - measure" association to one_to_many
- Change "measures - measure type" association to use `measure_type_id` key
- Replace `description` with `formatted_description` for `*_search` endpoints
- Fix geographical area eager loading
- Move certificates search to elasticsearch
- Move footnotes search to elasticsearch
- Move additional code search to elasticsearch
- Update `puma` to 3.12.2
- Update chapter notes

### Removed
- Remove `*_ids` methods from models


## [August 07, 2019](https://github.com/bitzesty/trade-tariff-backend/compare/1262198130f31d51331cad9ad4ef18ea95a96b2e...fdb42e59937ff691ecbbe7a36042a4453f362b7e)

### Added
- Produces printable Trade Tariff PDFs
- Use PaaS s3 broker for PDF storage
- Use `redlock-rb` gem
- Add elasticsearch caching for heavy headings
- Add search services for additional codes, quotas

### Changed
- API v2 fixes
- Reindex in batches
- Move admin related api to separate namespace
- Use `uktt` for Bitzesty gitlab profile
- Fix eager loading for commodities API v2

### Removed
- Remove `.json` from hrefs in goods_nomenclature API v2 responses
- Remove admin related attributes from API v2 responses (e.g. notes count)


## [May 7, 2019](https://github.com/bitzesty/trade-tariff-backend/compare/fce07ae3b07bfa3b758df115e8113dd25f876cdf...1f064896d4576e86ae56ab900512ef1c02db4466)

### Added
- Add and apply `govuk-lint`
- Add `scout`
- Switch to blue green deploy plugin
- Extract API v2
- Use JSONAPI specs

### Changed
- Update `pg` to 1.1.3 and `sequel` to 5.16.0
- Resolved agri quotas issue
- Use `Date.current` instead of `Date.today`
- Update `ruby` to 2.6.1
- Upgrade to `rails` 5.1.6.2
- Fix `0%` duty measures
- Use the type id rather than the description for VAT measure type detection
- Update deploy to use london region

### Removed
- Remove `national` ordering of measures as all measures are national


## [January 4, 2019](https://github.com/bitzesty/trade-tariff-backend/compare/4b3fea89ea79960c9fa93ba0699da51ed389c80a...017ae076d96b95914a5fd264cbb6d999bf9c8d2b)

### Added
- Add browserconfig.xml
- Add updated_at to sections
- API v1: add list of legal acts for measure
- API v1: add producline_suffix to heading commodities response
- Use PaaS redis service
- Use redis store for caching
- Use PaaS elasticsearch service
- GitlabCI integration
- Search improvements
- Add chapter guidance links
- Fix various data and formatting issues

### Changed
- Disable rabl caching
- Fix QuotaOrderNumber pk for oplog plugin
- Setup guide
- Set size for complete_abrogation_regulation_id according to TARIC documentation
- Change size 3 to 6 for measure_type_id column
- Update Elasticsearch indexes to use "text" or "keyword instead of "string" data type
- Update `elasticsearch` gem to 6.1.0
- Update `ruby` to 2.5.3

### Removed
- Delete outdated specs
- Remove `dalli` gem
- Remove CircleCI integration


## [August 8, 2018](https://github.com/bitzesty/trade-tariff-backend/compare/f8815c69d3bb98ce66ce007b84b8f299bd452ee4...037ace4adb903c98865c0df359040043097f898f)

### Added
- API v1: Add information about section, chapter notes and footnotes to non declarable heading
- Data migrations & rake tasks
- Display EUR duty amount on hover
- Handle presence errors, logging

### Changed
- Format duty expressions in GBP
- Update `rails` to 5.1.5
- Updated `sinatra` gem to 2.0.2
- Update `ruby` version to 2.5.0


## [August 28, 2017](https://github.com/bitzesty/trade-tariff-backend/compare/f435635...ce68659)

### Added
- Search Suggestions api and service
- `holidays` gem
- SearchReference to exact match to redirect on frontend
- CodesMapping
- Separately preload geo areas

### Changed
- `Rails` upgraded to 5.1.3
- Update `ruby` version to 2.4.1
- `gds-sso` upgraded to 13.2

### Removed
- Gov UK holidays checker
- HMRC request to remove Litre of Alcohol description
- Commodity codes api
- Removed geo areas from eager loading for fetching commodity measures
- ActionDispatch::ParamsParser::DEFAULT_PARSERS was deprecated and `remove_parsers.rb` initializer was removed


## [ May 27, 2017 ](https://github.com/bitzesty/trade-tariff-backend/compare/37f6244...e2691fc)

Maintained at now at the Bit Zesty repo - not the alphagov one.

### Added
- Snyk
- Sentry (Error tracking)
- Data migrations table
- api/v1/commodities/codes
- Holidays checker

### Changed
- Travis to CircleCI
- Updated ElasticSearch to 5.3.0
- Search term form :t to :q
- Data migrations flow - each data migration runs only once
- Upgraded rails to 4.2.8
- Upgraded test group gems

### Removed
- End national footnote 05 014


## [August 01, 2016]

### Added
- Add ReindexModelsWorker to run everyday at 01:00
- Add data migration that adds MeasureTypeDescription records that were added by the admin in the old production db.
- Add `dalli` gem
- Add `lograge` gem
- Add `rack-timeout` gem
- Add low level caching in the `changes` endpoints.

### Changed
- Hide Measures which should not be displayed
- Sort excluded countries alphabetically
- Update declarable object that have more than 1 `3rd country duty measure`, to show them as ‘variable’ rather than concatenating all measures.
- Update gems gds-sso
- Switch from memory_store to dalli_store (`Memcached`)
- Update deployment to notify slack.
- Deploy script also push the worker app.
- Update README file.
- Deploy script will the worker app to create a clone that will run migrations.
- Update frecuency of the `UpdatesSynchronizerWorker`
- Optimize the geographical area endpoint.
- Do not log smoke requests

### Fixed
- Fix sibling calculation
- Fix eager load method for `referenced` polymorphic association of the `SearchReference` model.
- Fix flaky specs.

### Removed
- Remove outdated cop.
- Remove Home Controller.
- Remove sprockets railtie and disable the assets pipeline
- Remove assets folders.
-	Remove assets related gems.
- Remove `jenkins.sh` file.
- Remove the `referenced` node in the search endpoint response.
- Remove the `ReindexModelsWorker` from the recurring jobs.

[August 01, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/bef256813cd3c55e6ef7f42e72d9968a9ad06c63...95896a60459b5639993244d9c8c8f4fe4824349a

## [July 15, 2016]

### Added
- Add rake task to kick off UpdatesSynchronizerWorker.
- Add logs to the UpdatesSynchronizerWorker.
- Add missing data migration to update the `ChapterNote` chapter_id reference

### Changed
- Update frecuency of the UpdatesSynchronizerWorker to run at every hour.
- Update the TarifUpdateDownlader class to not request HMRC for the taric update if the file is present.
- Move `newrelic_rpm` out of just production env.
- Allow configration of db pool via DB_POOL env in production.
- Update the yaml files for Section and Chapter Notes.

### Fixed
- Fix spec, geographical_area needs to be valid on or before measure.
- Fix expected `Commodity`order, to match the same results from the original mysql query.

### Removed
- Remove unnecessary data migration now that we are in postgresql

[July 15, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/e4f1dd01bde93a99778e1ec9d9b3132ad3e5915b...bef256813cd3c55e6ef7f42e72d9968a9ad06c63

## [July 09, 2016]

### Added
- Due to loss of CHIEF files, we added the records from the old production DB with CSV files.
- Add rake task to insert the missing records back.
- Add `aws-sdk-rails` to send emails with Amazon SES.

### Changed
- Update CHIEF models to load the right table name.
- Do not store the sidekiq error backtrace in redis.
- Do not retry the UpdatesSynchronizerWorker.
- Set the sender of sync emails as an environment variable.
- Update `newrelic` gem and config.
- Update the algorith of the XML parser class.
- Update the `sentry-raven` gem.

### Fixed
- Avoid bad queries because of sequel assumes invalid table name.
- Fix invalid encoding when reading the CHIEF file


### Removed
- Remove code that overrided elasticsearch connection
- Remove the `aws-ses` gem
- Remove unused rake task for initial seed files.

[July 09, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/15070c5027638708633612db9926fefb8815e0bd...e4f1dd01bde93a99778e1ec9d9b3132ad3e5915b

## [June 28, 2016]

### Added
- Use Amazon S3 in production when saving tariff updates.

### Changed
- Reduce the Index search max size for compatibility with  ElasticSearch 2.3.3
- Replace Airbrake with Sentry
- Update elasticsearch gems
-	Update to Ruby 2.3.1
- Update CircleCI config
- Move sequel configuration to `application.rb`
- Move rspec-rails and factory_girl_rails gems to the test group.
- Require factory girl only when tests are run, bugfix
- Replace memcached with memory store for caching
- Update README
- Ensure `puma` establishes the connection on boot for SequelRails

### Fixed
- Fix issue with factory_girl_rails was being loaded while doing `rake db:create` breaking the task.

### Removed
- Remove `logstasher`
- Remove `brakeman`

[June 28, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/371ee64288877f1f9bad603368e777454db2ebeb...15070c5027638708633612db9926fefb8815e0bd

## [May 05, 2016]

### Added
- New class TaricUpdateDownloader
- Add `dotenv-rails` to deal with env variables under development
- Trap emails in development with `mailcatcher`

### Changed
- Move support config of factory girl
- Move tests for Chief Update download method
- Move specs to tariff downloader
-	Update specs of TaricUpdate class
- Refactor and add specs to Response class
- Updates to README
- Replace `pry-nav` which is `pry-byebug`
-	Use the fork from database_cleaner with the sequel fix.
- Replace cron with `sidekiq-scheduler`

### Fixed
- Fix typo in sql query, bad column name

### Removed
- Remove perform_download proxy method from BaseUpdate
- Remove duplicated tests
- Remove unnecessary config for autoload path
-	Remove warnings of constant redefinition
- Remove unnecessary requires
- Remove `foreman` from the Gemfile

[May 05, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/89c7e3b3d76ff0903b730cbee32a6b42a33b7805...371ee64288877f1f9bad603368e777454db2ebeb

## [April 20, 2016]

### Added
- Add more tests for the Taric Update class
- Extract perform_download method to `TariffDownloader` class
- Add present? and empty? methods to `Response` class

### Changed
- Refactor Taric Update class
- Update deprecations in specs
- Method `validate_file!` now expects a string
- Update specs to do not mock exceptions
- Replace Nokogiri for xml validations with Ox
- Refactor download method from TariffSynchronizer
- Rubocop updates
- Update tariff task descriptions
- Update tariff synchronizer specs
- Move database cleaner configuration to a file.

### Removed
- Remove code duplication.
- Remove unused logger methods.
- Remove redundants `begin`

[April 20, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/52dbcc7f7ae12a397235381806943ff1db320b7c...15fffae97561f87607c52d4d037d507b43989928


## [March 31, 2016]

### Added
- More tests for chief importer process
- More tests for tariff syncronizer process
- Add .rspec global config to git

### Changed
- Refactor TariffImporter, fix and add more tests
- Remove the creation of custom files for loggers
- Configure Rails.logger to log to both STDOUT and development.log file.
- Switch from Unicorn to Puma
- Do not exclude schema dumps from git
- Configure sequel to generate the schema format in sql
- Update rails_helper and spec_helper config
- Update `fakefs` gem
- Remove rspec deprecations.
- Update synchronizer logger spec

### Fixed
- Disabling external requests in tests.
- Spec fixes

### Removed
- Remove gems `test-unit`, `ci_reporter_rspec`, `minitest` and `shoulda-matchers` from test bundler group.
- Remove `capistrano`
- Remove `rspec-guard`

[March 31, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/36e7f1e9ed2d3b89f2d34a3286b052a53499f3f4...c4d812da4656d03f5c52c0e4c7c303bf1a6b1790


## [March 15, 2016]

### Changed
- Refactor and improve log messages for importer
- Update codebase to be compatible with postgresql
- Style fixes
- Major refactor of classes.

### Fixed
- Fixing all tests breaking because of postgresql compatibility
- Remove mysql functions, delegate to sequel.
- Fix queries that are not stardard SQL
- Fix routes constraints
- Remove code rescuing from `Exception`


[March 15, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/9f9ce0824668aebf930fb182bc9c50fa2ad3ad49...36e7f1e9ed2d3b89f2d34a3286b052a53499f3f4

## [March 07, 2016]

### Changed
- Upgraded `sequel` gem
- Bump ruby version to 2.2.3
- Update log error messages
- Refactor sync process

### Fixed
- Fix issue with polymorphic association
- Fix issues with constants been redefined

### Removed
- Get rid of travis.

[January 26, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/e23e7042d178f4f85b4bd09fc2c4296aada6bce2...9f9ce0824668aebf930fb182bc9c50fa2ad3ad49


## [March 01, 2016]

### Added
- Missing configuration of rails for rails 4.
- Configuration for timezone used by the application.

### Changed
- Upgraded `libv8` gem
- Gem `rails_12factor` moved to production.
- Gem `newrelic` moved to production.
- Replace the parsing of XML from Nokogiri to Ox
- Performance improvements in the import process.

### Fixed
- Set timezone configuration for Sequel
- Fixed tests with timezone issues


[March 01, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/187ffdc9250cd08f25036151d4935ff41b5a00af...e23e7042d178f4f85b4bd09fc2c4296aada6bce2


## [January 26, 2016]

### Added
- Configuration for `breakman`as a CircleCI engine.

### Changed
- Upgraded `rails` to version 4.2.5.1

[January 26, 2016]: https://github.com/bitzesty/trade-tariff-backend/compare/af7d422...b669a0d

## [December 09, 2015]

### Added
- CircleCI configuration

### Changed
- Upgraded `sidekiq` to version 3.4.2
- Upgraded `uglifier` to version 2.7.2
- Upgraded `nokogiri` to version 1.6.7

### Fixed
- Countries are now accessed by the time machine

### Removed
- Gem `bundler_audit` in favor running as a CircleCI engine.
- Js and css linters, this app serves an API.
- `Rails` 3 script

[December 09, 2015]: https://github.com/bitzesty/trade-tariff-backend/compare/a86a349...c6f28b02

## [release_931...release_940](https://github.com/alphagov/trade-tariff-backend/compare/release_931...release_940)
### Changed
- Rails update to 4.2.3
- Rspec update and changed to rspec syntax, depreication warning fixes.
- gds-sso fixes for AR and Sequel differences

## [release_912...release_931](https://github.com/alphagov/trade-tariff-backend/compare/release_912...release_931)

### Changed
- Modified default pagination from 30 to 20 items per page
- Modified updates pagination to 60 updates per page
- Fixed bundler audit in production
- Upgrade Ruby version to 2.2.2
- Upgrade Rails gem version to 4.2.0 and related gems
- Upgrade MySql gem version to 0.3.13 for ruby compatibility
- Upgrade gds-sso gem version to 10.0
- Added a control to see if the update file can be XML/CSV parsed before marking it as pending

### Added
- Added pagination to Rollback controller

## [release_903...release_912](https://github.com/alphagov/trade-tariff-backend/compare/release_903...release_912)
### Changed
- QuotaCriticalEvent primary key modified to include `occurrence_timestamp` fixes 2015-01-02 sync issue
- A-Z pages fixed with move to serializers for the api
- Increase the retries count and sleep time between failed downloads
- Updated nokogiri, sprokets, breakman for security

### Added
- [budler-audit](https://github.com/rubysec/bundler-audit) added to check for security vulnerabilities

## [release_878...release_903](https://github.com/alphagov/trade-tariff-backend/compare/release_878...release_903)
### Changed
- Upgraded Rails to 4.1.8 from 3.2.17
- Upgraded Ruby to 2.1.4 from 2.0.0
- Replacing redis lock with an implementation that does not expire if work is in progress
- SSL 3.0 removed for tariff update file downloading
- Minor formatting fix for duty expressions
- Fixing ME1 conformance validation

### Added
- Logging of conformance errors in admin
- Retry downloading of files
- trade-tariff-suite specs which were not covered in the backend specs

### Removed
- Front end code (as backend only serves API)
- DB locking code (we moved to a redis lock)
