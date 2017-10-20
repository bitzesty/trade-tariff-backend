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
    # do the xml parsing depending on records root element name
    # XmlParser::Reader.new(file, "record", handler).parse

    ActiveSupport::Notifications.instrument("cds_imported.tariff_importer",
                                            filename: @cds_update.filename)
  end

  class XmlProcessor
    def initialize(issue_date)
      @issue_date = issue_date
    end

    def process_xml_node(hash_from_node)
      begin

        # TODO:
        # do the mapping and create record in db

      rescue StandardError => exception
        ActiveSupport::Notifications.instrument("cds_failed.tariff_importer", exception: exception, hash: hash_from_node)
        raise ImportException.new
      end
    end
  end
end
