class CdsImporter
  class EntityMapper
    ALL_MAPPERS = CdsImporter::EntityMapper::BaseMapper.descendants.freeze

    delegate :instrument, to: ActiveSupport::Notifications

    def initialize(key, values)
      @key = key
      @values = values
    end

    def import
      # select all mappers that have mapping_root equal to current xml key
      # it means that every selected mapper requires fetched by this xml key
      # sort mappers to apply top level first
      # e.g. Footnote before FootnoteDescription
      mappers = ALL_MAPPERS.select  { |m| m.mapping_root == @key }
                           .sort_by { |m| m.mapping_path ? m.mapping_path.length : 0 }

      mappers.each do |mapper|
        instances = mapper.new(@values).parse
        instances.each do |i|
          if TariffSynchronizer.cds_logger_enabled
            save_record(i)
          else
            save_record!(i)
          end
        end
      end
    end

    private

    def save_record!(record)
      record.save(validate: false, transaction: false)
    end

    def save_record(record)
      record.save(validate: false, transaction: false)
    rescue StandardError
      instrument("cds_error.cds_importer", record: record, xml_key: @key, xml_node: @values)
      false
    end
  end
end
