require 'nokogiri'

require 'tariff_importer/logger'
require 'tariff_importer/importers/taric_importer/transaction'

class TaricImporter
  class ImportException < StandardError
    attr_reader :original

    def initialize(msg = "TaricImporter::ImportException", original=$!)
      super(msg)
      @original = original
    end
  end

  cattr_accessor :opening_element
  self.opening_element = 1

  cattr_accessor :transaction_node
  self.transaction_node = 'env:transaction'

  attr_reader :path, :issue_date

  def initialize(path, issue_date = nil)
    @path = path
    @issue_date = issue_date
  end

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
      rescue RuntimeError, StandardError => exception
        ActiveSupport::Notifications.instrument("taric_failed.tariff_importer", exception: exception,
                                                                                xml: xml)

        raise ImportException.new
      end
    end
  end
end
