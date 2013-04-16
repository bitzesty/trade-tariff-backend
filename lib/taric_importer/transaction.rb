class TaricImporter < TariffImporter
  class Transaction
    include TaricImporter::Helpers::StringHelper

    attr_reader :record_stack

    def initialize(transaction, issue_date)
      @issue_date = issue_date
      @transaction = transaction
      @record_stack = []

      verify_transaction
    end

    def persist(processor = RecordProcessor)
      [@transaction['transaction']['app.message']].flatten.each do |message|
        @record_stack << processor.new(message['transmission']['record'], @issue_date).process!
      end

      # deletions return nil from process! so #compact to skip them
      @record_stack = @record_stack.compact
    end

    # validate each record and raise ValidationError if any fails
    # ending import process
    def validate
      while (record = record_stack.pop)
        unless record.valid?
          record.invalidated_by = record.transaction_id
          record.invalidated_at = Time.now
          record.save(validate: false)
        end
      end
    end

    private

    def verify_transaction
      if @transaction['transaction'].blank? || @transaction['transaction']['app.message'].blank?
        raise ArgumentError.new("TARIC transaction does not have required attributes")
      end
    end
  end
end
