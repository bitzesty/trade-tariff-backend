*SETUP GUIDE*

*1: SETUP BACKEND APP DB*

```default: &default
  adapter: postgresql
  encoding: utf8
  pool: 5

development:
  <<: *default
  database: tariff_development

test:
  <<: *default
  database: tariff_test

production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>
  pool: <%= ENV['DB_POOL'] || ENV['MAX_THREADS'] || 5 %>```
(edited)
`config/database.yml`
`bundle exec rake db:create`
*2: SETUP ADMIN APP DB*
```default: &default
  adapter: postgresql
  encoding: utf8
  pool: 5

development:
  <<: *default
  database: tariff_admin_development

test:
  <<: *default
  database: tariff_admin_test

production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>
  pool: <%= ENV['DB_POOL'] || ENV['MAX_THREADS'] || 5 %>```
Recommended PG version: `psql (PostgreSQL) 9.6.9`
`bundle exec rake db:create`
ALL APPS RUBY: `2.5.0` (edited)
*STEP 3: Setup ElasticSearch*
Need to use Elastcisearch `5.3.0`
https://www.elastic.co/downloads/past-releases
https://www.elastic.co/guide/en/beats/libbeat/5.3/elasticsearch-installation.html
https://gist.github.com/cigolpl/b8c849ecadd2af1b2f4853ea302f3d7d
https://www.elastic.co/guide/en/elasticsearch/reference/5.3/gs-installation.html
*NOTE:* check ES status here http://127.0.0.1:9200/
```{
  "name" : "E6nqhJC",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "RkQA0wejSZWfARdgayt6cg",
  "version" : {
    "number" : "5.3.0",
    "build_hash" : "3adb13b",
    "build_date" : "2017-03-23T03:31:50.652Z",
    "build_snapshot" : false,
    "lucene_version" : "6.4.1"
  },
  "tagline" : "You Know, for Search"
}```
*STEP 4: Setup env vars for BACKEND APP*
`.env`
```TARIFF_SYNC_USERNAME=username
TARIFF_SYNC_PASSWORD=password
TARIFF_SYNC_HOST=http://example.com
TARIFF_SYNC_EMAIL=user@example.com
TARIFF_MEASURES_LOGGER=0
TARIFF_FROM_EMAIL=no-reply@example.com
AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_REGION=us-east-1
AWS_BUCKET_NAME=trade-tariff-backend
RACK_TIMEOUT_SERVICE=60```
*STEP 5: For admin app just create DB and run database migrations (no need any dump)*
`bundle exec rake db:create db:migrate`
*STEP 6: Setup env var for ADMIN app*
`.env`
`TARIFF_API_HOST=http://127.0.0.1:3018`
*STEP 7: Load database dump to BACKEND APP*
`psql tariff_development < tariff_development.sql`
*NOTE:* There can be possible errors while loading dump with missing role in Postgresql
Smth like:
`rdsbroker_266a9334_2e5d_4234_b2bf_5f5ebf7d973d_manager`
missing role
Solution:
go to psql console and add missing role like: (edited)
`CREATE ROLE rdsbroker_266a9334_2e5d_4234_b2bf_5f5ebf7d973d_manager WITH CREATEDB;`
*STEP 8: After loading of dump - re index Elastic search* (edited)
`bundle exec rake tariff:reindex`
Checkout stats of ES here http://localhost:9200/_stats?pretty
Can take around 1 or 2 hours to reindex all docs
*STEP 9: Setup env variables for Frontend app*
`.env`
```TARIFF_API_HOST=http://127.0.0.1:3018

TARIFF_FROM_EMAIL=no-reply@example.com
TARIFF_TO_EMAIL=support@example.com

AWS_ACCESS_KEY_ID=aws_access_key_id
AWS_SECRET_ACCESS_KEY=aws_secret_access_key
AWS_REGION=us-east-1
AWS_BUCKET_NAME=trade-tariff-frontend

RACK_TIMEOUT_SERVICE=60```
*STEP 10: Run apps on proper ports*
Run apps on local
backend: `rails s webrick -p 3018`
frontend: `rails s webrick -p 3000`
admin: `rails s webrick -p 7000`
*STEP 11: Oper frontend root URL*

localhost:3000/trade-tariff/sections
