require 'nokogiri'

require 'taric_importer/transaction'
require 'taric_importer/record_processor'
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

  cattr_accessor :opening_element
  self.opening_element = 1

  cattr_accessor :transaction_node
  self.transaction_node = 'env:transaction'

  def import
    xml = nil

    ActiveSupport::Notifications.instrument("taric_imported.tariff_importer", path: path) do
      begin
        handler = File.open(path, "r")
        reader = Nokogiri::XML::Reader(handler, nil, nil, Nokogiri::XML::ParseOptions::RECOVER | Nokogiri::XML::ParseOptions::NOERROR | Nokogiri::XML::ParseOptions::NONET)
        reader.each do |node|
          if node.name == self.transaction_node && node.node_type == self.opening_element
            xml = Nokogiri::XML(node.outer_xml).remove_namespaces!
            transaction = Transaction.new(Hash.from_xml(xml.to_s), issue_date)
            transaction.persist
            transaction.validate
          end
        end
      rescue StandardError => exception
        ActiveSupport::Notifications.instrument("taric_failed.tariff_importer", exception: exception,
                                                                                xml: xml)
        raise ImportException.new
      end
    end
  end
end
