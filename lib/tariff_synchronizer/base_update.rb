module TariffSynchronizer
  class BaseUpdate
    class InvalidArgument < StandardError; end

    attr_reader    :file_path, :file_name, :date
    cattr_accessor :update_priority

    delegate :logger, to: TariffSynchronizer

    def initialize(file_path)
      raise InvalidArgument.new("expects a Pathname object") unless file_path.is_a?(Pathname)

      @file_path = file_path
      @file_name = file_path.basename.to_s
      @date = FileService.get_date(@file_name)
    end

    def move_to(state_folder)
      destination_path = File.join(Rails.root,
                                   TariffSynchronizer.send("#{state_folder}_path".to_sym),
                                   file_name)

      FileUtils.mv file_path, destination_path
    end

    def self.sync
      unless pending_from == Date.today
        (pending_from..Date.today).each do |date|
          download(date)
        end
      end
    end

    def self.pending_from
      FileService.get_date(last_download_date) || TariffSynchronizer.initial_update_for(update_type)
    end

    def self.update_type
      raise "Update Type should be specified in inheriting class"
    end

    private

    def self.last_download_date
      Dir[query_for_last_file].map{|p| Pathname.new(p).basename.to_s }
                              .sort
                              .last
    end

    def self.update_path(date, file_name)
      File.join(Rails.root, TariffSynchronizer.inbox_path, "#{date}_#{file_name}")
    end
  end
end
