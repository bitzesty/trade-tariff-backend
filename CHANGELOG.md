# Change Log

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
