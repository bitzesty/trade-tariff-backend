require 'tariff_importer/importers/taric_importer/record_processor'
require 'tariff_importer/importers/taric_importer/helpers/string_helper'

class TaricImporter
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

      @record_stack = @record_stack.compact
    end

    # validate each record and raise ValidationError if any fails
    # ending import process
    def validate
      while (record = record_stack.pop)
        record.validate!
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
