module TariffSynchronizer
  class PendingUpdate
    attr_reader :file_path,
                :update_processor,
                :date

    delegate :apply, :update_priority, to: :update_processor

    def initialize(file_path)
      @file_path = file_path
      @date = FileService.get_date(file_path)
      @update_processor = pick_update_processor(file_path).new(file_path)
    end

    def self.all
      Dir["#{TariffSynchronizer.failbox_path}/*", "#{TariffSynchronizer.inbox_path}/*"].map{ |file_path| new(Pathname.new(file_path)) }
    end

    def to_s
      file_path
    end

    private

    def pick_update_processor(file_path)
      if file_path.to_s.ends_with?('xml')
        TaricUpdate
      elsif file_path.to_s.ends_with?('txt')
        ChiefUpdate
      end
    end
  end
end
