require 'delegate'
require 'date'
require 'pry'

require 'logger'

require 'active_support/concern'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/inclusion'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/class/attribute_accessors'

class TariffImporter
  class NotFound < StandardError; end

  cattr_accessor :logger
  self.logger = Logger.new('log/importer-error.log')

  attr_reader :path, :importer, :issue_date

  delegate :import, to: :importer

  def initialize(path, importer, issue_date = Date.today)
    if File.exists?(path)
      @path = path
      @importer = importer.to_s.constantize.new(path, issue_date)
    else
      raise NotFound.new("#{path} was not found.")
    end
  end
end

require 'tariff_importer/importers/chief_importer'
require 'tariff_importer/importers/taric_importer'
