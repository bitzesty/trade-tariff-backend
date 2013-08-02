require 'forwardable'

class TaricImporter < TariffImporter
  class Transaction
    extend Forwardable

    include TaricImporter::Helpers::StringHelper

    def_delegator ActiveSupport::Notifications, :instrument

    def initialize(transaction, issue_date)
      @issue_date = issue_date
      @transaction = transaction
      @record_stack = []

      verify_transaction
    end

    def persist(processor = RecordProcessor)
      [@transaction['transaction']['app.message']].flatten.each do |message|
         @record_stack.push(
           processor.new(message['transmission']['record'], @issue_date)
                    .process!
         )
      end
    end

    def validate
      while (record = @record_stack.pop)
        unless record.conformant_for?(record.operation)
          instrument("conformance_error.taric_importer", record: record)
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
