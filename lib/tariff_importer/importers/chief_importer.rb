require 'csv'

require 'tariff_importer/importers/chief_importer/entry'
require 'tariff_importer/importers/chief_importer/start_entry'
require 'tariff_importer/importers/chief_importer/end_entry'
require 'tariff_importer/importers/chief_importer/change_entry'

require 'tariff_importer/importers/chief_importer/strategies/base_strategy'
require 'tariff_importer/importers/chief_importer/strategies/strategies'

class ChiefImporter
  class ImportException < StandardError; end
  module SourceParser
    def from_source
      opts = { encoding: 'ISO-8859-1' }

      if is_path?
        CSV.foreach(data, opts) do |line|
          yield line
        end
      else
        CSV.parse(data, opts) do |line|
          yield line
        end
      end
    end
  end

  # TODO extend this
  cattr_accessor :relevant_tables
  self.relevant_tables = %w(MFCM TAMF TAME)

  cattr_accessor :start_mark
  self.start_mark = "AAAAAAAAAAA"

  cattr_accessor :end_mark
  self.end_mark = "ZZZZZZZZZZZ"

  attr_reader :data, :processor, :start_entry, :end_entry, :file_name

  delegate :extraction_date, to: :start_entry
  delegate :record_count, to: :end_entry
  delegate :logger, to: ::TariffImporter

  def initialize(data)
    @data = data
  end

  def import
    begin
      data.from_source do |line|
        entry = Entry.build(line)

        if entry.is_a?(StartEntry)
          @start_entry = entry
        elsif entry.is_a?(EndEntry)
          @end_entry = entry
        else # means it's ChangeEntry
          next unless entry.relevant?

          entry.origin = @data.filename
          entry.process!
        end
      end
    rescue Exception => e
      logger.error e.message

      raise ImportException
    end
  end
end
