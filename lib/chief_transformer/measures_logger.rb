class ChiefTransformer
  class MeasuresLogger
    class << self
      def add_created(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(:created), "a+") do |f|
          f.puts("#{Time.now} Measure Candidate: #{candidate.values.inspect}")
        end
      end

      def add_failed(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(:failed), "a+") do |f|
          f.puts("#{Time.now} Measure Candidate: #{candidate.values.inspect}")
          f.puts("Errors: #{candidate.errors}")
        end
      end

      def upload_to_s3
        return unless TariffSynchronizer.measures_logger_enabled

        [:created, :failed].each do |type|
          path = File.join(TariffSynchronizer.root_path, "measures", "#{Date.today}-#{type}.txt")
          TariffSynchronizer::FileService.upload_file(tmp_file_path(type), path)
        end
      end

      def tmp_file_path(type)
        File.join(Rails.root, "data", "measures", "#{Date.today}-#{type}.txt")
      end
    end
  end
end
