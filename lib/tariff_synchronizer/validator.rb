# Works as part of synchronization process.
# Validates imported entries for specific update and returns invalid ones.
# Used in synchronization success email to identify records that failed
# conformance (and other, if present) validations.

module TariffSynchronizer
  class Validator
    def self.invalid_entries_for(pending_update)
      new(pending_update).result
    end

    attr_reader :update

    def initialize(update)
      @update = update
    end

    def result
      invalid_records.inject({}) { |memo, invalid_record|
        memo.deep_merge(Hash[invalid_record.class,
                             Hash[invalid_record.pk,
                                  invalid_record.errors]])
      }
    end

    private

    def records
      update.affected_datasets.map(&:all).flatten
    end

    def invalid_records
      records.select { |record| !record.valid? }
    end
  end
end
