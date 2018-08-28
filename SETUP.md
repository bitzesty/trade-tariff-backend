## SETUP GUIDE

:rocket:

#### STEP 1: Setup BACKEND APP DB

Settings for `config/database.yml`

```
default: &default
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
  pool: <%= ENV['DB_POOL'] || ENV['MAX_THREADS'] || 5 %>
  
```

Run `bundle exec rake db:create`

#### STEP 2: Setup ADMIN APP DB

```
default: &default
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
  pool: <%= ENV['DB_POOL'] || ENV['MAX_THREADS'] || 5 %>
```

Recommended PG version: **psql (PostgreSQL) 9.6.9**

Run `bundle exec rake db:create`

All apps use Ruby **2.5.0**

### STEP 3: Setup ElasticSearch

Need to use Elastcisearch `5.3.0`

[https://www.elastic.co/downloads/past-releases](https://www.elastic.co/downloads/past-releases)

[https://www.elastic.co/guide/en/beats/libbeat/5.3/elasticsearch-installation.html](https://www.elastic.co/guide/en/beats/libbeat/5.3/elasticsearch-installation.html)

[https://gist.github.com/cigolpl/b8c849ecadd2af1b2f4853ea302f3d7d](https://gist.github.com/cigolpl/b8c849ecadd2af1b2f4853ea302f3d7d)

[https://www.elastic.co/guide/en/elasticsearch/reference/5.3/gs-installation.html](https://www.elastic.co/guide/en/elasticsearch/reference/5.3/gs-installation.html)

*NOTE:* check Elasticsearch status here http://127.0.0.1:9200/

```
{
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
}
```

#### STEP 4: Setup env vars for BACKEND APP

FIle: `.env`

```
TARIFF_SYNC_USERNAME=username
TARIFF_SYNC_PASSWORD=password
TARIFF_SYNC_HOST=http://example.com
TARIFF_SYNC_EMAIL=user@example.com
TARIFF_MEASURES_LOGGER=0
TARIFF_FROM_EMAIL=no-reply@example.com
AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_REGION=us-east-1
AWS_BUCKET_NAME=trade-tariff-backend
RACK_TIMEOUT_SERVICE=60
```

**STEP 5: For ADMIN APP just create a database and run database migrations (no need any dump)**

Run `bundle exec rake db:create db:migrate`

#### STEP 6: Setup env var for ADMIN app

File: `.env`

```
TARIFF_API_HOST=http://127.0.0.1:3018
```

#### STEP 7: Load database dump to BACKEND APP

`psql tariff_development < tariff_development.sql`

*NOTE:* There can be possible errors while loading dump with missing role in Postgresql
Smth like:
`rdsbroker_266a9334_2e5d_4234_b2bf_5f5ebf7d973d_manager`
missing role

**Solution:**
Go to psql console and add missing role like: (edited)
`CREATE ROLE rdsbroker_266a9334_2e5d_4234_b2bf_5f5ebf7d973d_manager WITH CREATEDB;`

You might need to make those roles/users as a superuser

#### STEP 8: After loading of dump - re index Elastic search

`bundle exec rake tariff:reindex`
checkout stats of Elasticsearch here *http://localhost:9200/_stats?pretty* It can take around 1 or 2 hours to reindex all docs.

#### STEP 9: Setup env variables for FRONTEND APP

File: `.env`

```
TARIFF_API_HOST=http://127.0.0.1:3018
TARIFF_FROM_EMAIL=no-reply@example.com
TARIFF_TO_EMAIL=support@example.com

AWS_ACCESS_KEY_ID=aws_access_key_id
AWS_SECRET_ACCESS_KEY=aws_secret_access_key
AWS_REGION=us-east-1
AWS_BUCKET_NAME=trade-tariff-frontend

RACK_TIMEOUT_SERVICE=60
```

#### STEP 10: Run apps on proper ports

Run apps on local machine

```
backend: `rails s webrick -p 3018`
frontend: `rails s webrick -p 3000`
admin: `rails s webrick -p 7000`
```
You can set these ports in apps' `.foreman` file too. 

Example: In the backend app's `.foreman` file, set `port: 3018` and run `foreman start`

#### STEP 11: Open frontend root URL

Hit **localhost:3000/trade-tariff/sections** on the browser to check everything is working properly or not. If it gives some list of recrods then all is set :thumbsup:

