require 'nokogiri'

require 'taric_importer/transaction'
require 'taric_importer/record_processor'
require 'taric_importer/xml_parser'
require 'taric_importer/helpers/string_helper'

class TaricImporter < TariffImporter
  class ImportException < StandardError
    attr_reader :original

    def initialize(msg = "TaricImporter::ImportException", original=$!)
      super(msg)
      @original = original
    end
  end

  class UnknownOperationError < ImportException
  end

  def import(validate: true)
    ActiveSupport::Notifications.instrument("taric_imported.tariff_importer", path: path) do
      XmlParser::Reader.new(path, "record", XmlProcessor.new(issue_date, validate)).parse
    end
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
        ActiveSupport::Notifications.instrument("taric_failed.tariff_importer", exception: exception)
        raise ImportException.new
      end
    end
  end
end
