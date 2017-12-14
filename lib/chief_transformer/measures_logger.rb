# each line in *.json.txt files is a json object of measure candidate

class ChiefTransformer
  class MeasuresLogger
    class << self
      def add_created(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(Date.today, :created), "a+") do |f|
          f.puts(candidate.values.to_json)
        end
      end

      def add_failed(candidate)
        return unless TariffSynchronizer.measures_logger_enabled

        File.open(tmp_file_path(Date.today, :failed), "a+") do |f|
          f.puts(candidate.values.merge(errors: candidate.errors,
            mfcm: candidate.mfcm.values,
            tame: candidate.tame.values,
            tamf: candidate.tamf.values).to_json)
        end
      end

      def upload_to_s3
        return unless TariffSynchronizer.measures_logger_enabled

        [:created, :failed].each do |type|
          # we also need to upload all previous files in case process started not today
          dates = (ChiefTransformer::Processor.started_at..Date.today).to_a

          dates.each do |date|
            path = File.join(TariffSynchronizer.root_path, "measures", "#{date}-#{type}.json.txt")
            TariffSynchronizer::FileService.upload_file(tmp_file_path(date, type), path)
          end
        end
      end

      def tmp_file_path(date, type)
        File.join(Rails.root, "data", "measures", "#{date}-#{type}.json.txt")
      end
    end
  end
end
