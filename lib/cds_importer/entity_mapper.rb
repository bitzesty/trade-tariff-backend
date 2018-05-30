class CdsImporter
  class EntityMapper
    def initialize(key, values)
      @key = key
      @values = values
    end

    def import
      # sort mappers to apply top level first
      # e.g. Footnote before FootnoteDescription
      mappers = CdsImporter::EntityMapper::BaseMapper.descendants
                                                     .select  { |m| m.mapping_root == @key }
                                                     .sort_by { |m| m.mapping_path.to_s.length }

      failed = File.open("#{TariffSynchronizer.root_path}/cds/failed.json.txt", "a+")
      mappers.each do |mapper|
        instances = mapper.new(@values).parse
        instances.each do |i|
          i.save(validate: false, transaction: false)
        rescue StandardError => e
          puts "Failed: #{mapper}, #{e.message}"
          failed.puts("#{i.class}: #{i.to_json}")
          failed.puts(@values)
          failed.puts("--------------------------")
          next
        end
      end
      failed.close
    end
  end
end
