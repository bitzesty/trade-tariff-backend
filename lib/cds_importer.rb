require 'zip'
require 'cds_importer/xml_parser'
require 'cds_importer/entity_mapper'
Dir[File.join(Rails.root, 'lib', 'cds_importer/entity_mapper/*.rb')].each{|f| require f }

class CdsImporter
  class ImportException < StandardError
    attr_reader :original

    def initialize(msg = "CdsImporter::ImportException", original=$!)
      super(msg)
      @original = original
    end
  end

  class UnknownOperationError < ImportException
  end

  def initialize(cds_update)
    @cds_update = cds_update
  end

  def import
    handler = XmlProcessor.new(@cds_update.filename)
    gzip_file = TariffSynchronizer::FileService.file_as_stringio(@cds_update)

    Zip::File.open_buffer(gzip_file) do |archive|
      archive.entries.each do |entry|
        # Read into memory
        xml_stream = entry.get_input_stream
        # do the xml parsing depending on records root depth
        CdsImporter::XmlParser::Reader.new(xml_stream.read, handler).parse

        ActiveSupport::Notifications.instrument("cds_imported.tariff_importer", filename: @cds_update.filename)
      end
    end
  end

  class XmlProcessor
    def initialize(filename)
      @filename = filename
    end

    def process_xml_node(key, hash_from_node)
      begin
        hash_from_node['filename'] = @filename
        CdsImporter::EntityMapper.new(key, hash_from_node).import
      rescue StandardError => exception
        ActiveSupport::Notifications.instrument(
          "cds_failed.tariff_importer",
          exception: exception, hash: hash_from_node, key: key
        )
        raise ImportException.new
      end
    end
  end
end
