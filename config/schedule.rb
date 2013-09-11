set :output, { error: 'log/cron.error.log', standard: 'log/cron.log'}

# We need Rake to use our own environment
job_type :rake, "cd :path && govuk_setenv tariff-api bundle exec rake :task --silent :output"

every 1.hour do
  rake "tariff:sync:apply"
end
