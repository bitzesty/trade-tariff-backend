require 'delegate'
require 'date'
require 'logger'


class TariffImporter
  class NotFound < StandardError; end

  cattr_accessor :logger
  self.logger = Logger.new('log/importer-error.log')

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

require 'tariff_importer/importers/chief_importer'
require 'tariff_importer/importers/taric_importer'
