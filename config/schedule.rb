set :output, { error: 'log/cron.error.log', standard: 'log/cron.log'}

# We need Rake to use our own environment
job_type :rake, "cd :path && bundle exec rake :task --silent :output"

every 1.day, at: "8:00 pm" do
  rake "tariff:sync:apply"
end

every 1.day, at: "11:00 pm" do
  rake "tariff:sync:apply"
end
