require 'nokogiri'

require 'taric_importer/transaction'
require 'taric_importer/record_processor'
require 'taric_importer/xml_parser'

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

  def import
    XmlParser::Reader.new(path, "record", XmlProcessor.new).parse
  end

  class XmlProcessor
    def process_xml_node property
      transaction = Transaction.new(property, nil)
      transaction.persist
      transaction.validate
    end
  end
end
