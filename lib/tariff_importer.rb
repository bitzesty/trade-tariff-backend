require 'delegate'
require 'date'
require 'active_support/notifications'
require 'active_support/log_subscriber'

require 'tariff_importer/logger'

require 'tariff_importer/importers/chief_importer'
require 'tariff_importer/importers/taric_importer'

class TariffImporter
  class NotFound < StandardError; end

  attr_reader :path, :importer, :processor

  delegate :import, to: :importer

  def initialize(path, importer)
    if File.exists?(path)
      @path = path
      @importer = importer.to_s.constantize.new(path)
    else
      raise NotFound.new("#{path} was not found.")
    end
  end
end
