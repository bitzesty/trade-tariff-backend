class TaricImporter < TariffImporter
  class Transaction
    include TaricImporter::Helpers::StringHelper

    attr_reader :record_stack

    def initialize(transaction, issue_date)
      @issue_date = issue_date
      @transaction = transaction

      verify_transaction
    end

    def persist(processor = RecordProcessor)
      [@transaction['transaction']['app.message']].flatten.each do |message|
         processor.new(message['transmission']['record'], @issue_date)
                  .process!
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
