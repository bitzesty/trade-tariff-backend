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

  # we assume that all updates are valid
  def import
    handler = XmlProcessor.new(@cds_update.issue_date)
    file = TariffSynchronizer::FileService.file_as_stringio(@cds_update)
    # TODO:
    # do the xml parsing depending on records root depth
    # CdsImporter::XmlParser::Reader.new(file, "TariffHistoryItem", handler).parse


    ActiveSupport::Notifications.instrument("cds_imported.tariff_importer",
                                            filename: @cds_update.filename)
  end

  class XmlProcessor
    def initialize(issue_date)
      @issue_date = issue_date
    end

    def process_xml_node(hash_from_node)
      begin

        # TODO: apply hash_from_node for all mappers with mapping_root == hash_from_node parent key
        # create records in DB

      rescue StandardError => exception
        hash_from_node = {}
        ActiveSupport::Notifications.instrument("cds_failed.tariff_importer", exception: exception, hash: hash_from_node)
        raise ImportException.new
      end
    end
  end
end
