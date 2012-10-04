module TariffSynchronizer
  class PendingUpdate
    attr_reader :update_processor,
                :file_name

    delegate :apply, :update_priority, to: :update_processor

    def initialize(update)
      @file_name = update.filename
      @update_processor = pick_update_processor(update.update_type).new(update.values)
    end

    def self.all
      BaseUpdate.pending.all.map { |update| new(update) }
    end

    def to_s
      file_name
    end

    private

    def pick_update_processor(update_type)
      "TariffSynchronizer::#{update_type}".constantize
    end
  end
end
