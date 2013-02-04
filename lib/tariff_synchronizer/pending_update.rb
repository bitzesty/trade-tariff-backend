module TariffSynchronizer
  class PendingUpdate
    attr_reader :update,
                :file_name

    delegate :apply, :file_path, :issue_date, :update_type,
             :update_priority, :mark_as_failed, to: :update

    def initialize(update)
      @file_name = update.filename
      @update = update
    end

    def self.count
      BaseUpdate.pending_or_failed.count
    end

    def self.all
      BaseUpdate.pending_or_failed.all.map { |update| new(update) }
    end

    def to_s
      file_name
    end
  end
end
