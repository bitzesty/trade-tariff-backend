set :output, { error: 'log/cron.error.log', standard: 'log/cron.log'}

every 1.hour do
  rake "tariff:sync:apply"
end

every 1.day, at: '10pm' do
  rake "tariff:support:clean_national_measures"
end

