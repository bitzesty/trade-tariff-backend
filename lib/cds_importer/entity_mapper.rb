class CdsImporter
  class EntityMapper
    ALL_MAPPERS = CdsImporter::EntityMapper::BaseMapper.descendants.freeze

    delegate :instrument, to: ActiveSupport::Notifications

    def initialize(key, values)
      @key = key
      @values = values
      @filename = @values.delete("filename")
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
      values = record.values.except(:oid)

      values.merge!(filename: @filename)

      operation_klass = record.class.operation_klass

      if operation_klass.columns.include?(:created_at)
        values.merge!(created_at: operation_klass.dataset.current_datetime)
      end

      operation_klass.insert(values)
    end

    def save_record(record)
      save_record!(record)
    rescue StandardError => e
      instrument("cds_error.cds_importer", record: record, xml_key: @key, xml_node: @values, exception: e)
      nil
    end
  end
end
