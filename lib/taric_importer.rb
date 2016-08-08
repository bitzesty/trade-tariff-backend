require 'nokogiri'

require 'tariff_importer/logger'
require 'taric_importer/transaction'
require 'taric_importer/record_processor'
require 'taric_importer/xml_parser'
require 'taric_importer/helpers/string_helper'

class TaricImporter
  class ImportException < StandardError
    attr_reader :original

    def initialize(msg = "TaricImporter::ImportException", original=$!)
      super(msg)
      @original = original
    end
  end

  class UnknownOperationError < ImportException
  end

  def initialize(taric_update)
    @taric_update = taric_update
  end

  def import(validate: true)
    handler = XmlProcessor.new(@taric_update.issue_date, validate)
    file = TariffSynchronizer::FileService.file_as_stringio(@taric_update)
    XmlParser::Reader.new(file, "record", handler).parse
    ActiveSupport::Notifications.instrument("taric_imported.tariff_importer",
      filename: @taric_update.filename)
  end

  class XmlProcessor
    def initialize(issue_date, validate)
      @issue_date = issue_date
      @validate = validate
    end

    def process_xml_node hash_from_node
      begin
        transaction = Transaction.new(hash_from_node, @issue_date)
        transaction.persist
        transaction.validate if @validate
      rescue StandardError => exception
        ActiveSupport::Notifications.instrument("taric_failed.tariff_importer", exception: exception, hash: hash_from_node)
        raise ImportException.new
      end
    end
  end
end
