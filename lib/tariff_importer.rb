require 'delegate'
require 'date'
require 'active_support/notifications'
require 'active_support/log_subscriber'

require 'tariff_importer/logger'

class TariffImporter
  NotFound = Class.new(StandardError)

  attr_reader :path, :issue_date

  def initialize(path, issue_date = nil)
    if File.exists?(path)
      @path = path
      @issue_date = issue_date
    else
      raise NotFound.new("#{path} was not found.")
    end
  end
end
