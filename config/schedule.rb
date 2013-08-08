set :output, { error: 'log/cron.error.log', standard: 'log/cron.log'}

every 1.hour do
  rake "tariff:sync:apply"
end
