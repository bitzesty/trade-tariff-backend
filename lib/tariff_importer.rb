require 'delegate'
require 'date'
require 'logger'
require 'tariff_importer/data_unit'

class TariffImporter
  class NotFound < StandardError; end

  cattr_accessor :logger
  self.logger = Logger.new('log/importer-error.log')

  attr_reader :importer, :processor, :data

  delegate :import, to: :importer

  def self.import(path_or_data, importer)
    new(DataUnit.new(path_or_data, importer), importer).import
  end

  def initialize(data, importer)
    @importer = importer.to_s.constantize.new(data)
  end
end

require 'tariff_importer/importers/chief_importer'
require 'tariff_importer/importers/taric_importer'
