web: bundle exec rake cf:run_migrations db:migrate && bundle exec puma -C config/puma.rb
worker1: bundle exec sidekiq -C ./config/sidekiq.yml
worker2: bundle exec sidekiq -C ./config/sidekiq.yml
