class TariffImporter
  class DataUnit
    attr_reader :is_path, :data, :filename

    def initialize(path_or_data, importer)
      # initial and call import
      if path_or_data.is_a?(Pathname)
        @data = path_or_data
        @filename = @data.basename.to_s
        @is_path = true
      else
        @data = path_or_data.file
        @filename = path_or_data.filename
        @is_path = false
      end

      extend "#{importer}::SourceParser".constantize
    end

    alias :is_path? :is_path
  end
end
