govuk_defaults = '/etc/govuk/unicorn.rb'
instance_eval(File.read(govuk_defaults), govuk_defaults) if File.exist?(govuk_defaults)

worker_processes 4
