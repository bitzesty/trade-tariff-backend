require "delegate"
require "date"
require "active_support/notifications"
require "active_support/log_subscriber"
require "tariff_importer/logger"

class TariffImporter
  attr_reader :path, :issue_date

  def initialize(path, issue_date = nil)
    raise FileNotFoundError, "#{path} was not found." unless File.exist?(path)
    @path = path
    @issue_date = issue_date
  end

  def importer_logger(key, payload = {})
    ActiveSupport::Notifications.instrument("#{key}.tariff_importer", payload)
  end

  class FileNotFoundError < StandardError
  end
end
