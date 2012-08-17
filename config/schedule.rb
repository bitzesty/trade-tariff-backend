set :output, { error: 'log/cron.error.log', standard: 'log/cron.log'}

every 1.hour do
  rake "tariff:sync:download"
end

every 1.day, at: '5am' do
  rake "tariff:sync:apply"
end
