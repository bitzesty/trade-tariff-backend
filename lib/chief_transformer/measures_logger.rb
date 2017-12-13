# each line in *.json.txt files is a json object of measure candidate

class ChiefTransformer
  class MeasuresLogger
    class << self
      def add_created(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(:created), "a+") do |f|
          f.puts(candidate.values.to_json)
        end
      end

      def add_failed(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(:failed), "a+") do |f|
          f.puts(candidate.values.merge(errors: candidate.errors).to_json)
        end
      end

      def upload_to_s3
        return unless TariffSynchronizer.measures_logger_enabled

        [:created, :failed].each do |type|
          path = File.join(TariffSynchronizer.root_path, "measures", "#{Date.today}-#{type}.json.txt")
          TariffSynchronizer::FileService.upload_file(tmp_file_path(type), path)
        end
      end

      def tmp_file_path(type)
        File.join(Rails.root, "data", "measures", "#{Date.today}-#{type}.json.txt")
      end
    end
  end
end
