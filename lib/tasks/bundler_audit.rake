namespace :bundler do
  desc "Updates the ruby-advisory-db and runs audit"
  task :audit do
    require "bundler/audit/cli"
    %w(update check).each do |command|
      Bundler::Audit::CLI.start [command]
    end
  end
end
