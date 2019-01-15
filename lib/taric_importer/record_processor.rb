require 'forwardable'

require 'taric_importer/record_processor/record'
require 'taric_importer/record_processor/operation'
require 'taric_importer/record_processor/update_operation'
require 'taric_importer/record_processor/destroy_operation'
require 'taric_importer/record_processor/create_operation'

# If certain models need to be processed out in a different way
# (see RecordProcessor::CreateOperation, RecordProcessor::UpdateOperation etc)
# this is directory is the place for these overrides, e.g.:
#
#  class LanguageCreateOperation < CreateOperation
#    def call
#      Language.insert(record.attributes)
#    end
#  end
#
# NOTE: all operations must record model instance from #call
# NOTE: update operations should inherit from UpdateOperation, create
#       operations should inherit from CreateOperation and destroy
#       operations should inherit from DestroyOperation

Dir[File.join(Rails.root, 'lib', 'taric_importer', 'record_processor', 'operation_overrides', '*.rb')].each { |file|
  require file
}

class TaricImporter
  class RecordProcessor
    extend Forwardable

    def_delegator ActiveSupport::Notifications, :instrument

    OPERATION_MAP = {
      "1" => UpdateOperation,
      "2" => DestroyOperation,
      "3" => CreateOperation
    }.freeze

    # Instance of Record, containing extracted primary key, attributes etc
    attr_reader :record

    # Operation Class
    attr_reader :operation_class

    # The date of the update. NB not necessarily the current date.
    attr_accessor :operation_date

    def initialize(record_hash, operation_date = nil)
      self.record = record_hash
      self.operation_class = record_hash['update_type']
      self.operation_date = operation_date
    end

    def record=(record_hash)
      @record = Record.new(record_hash)
    end

    def operation_class=(operation)
      @operation_class = OPERATION_MAP.fetch(operation) {
        instrument("taric_unexpected_update_type.tariff_importer", record: record)

        raise TaricImporter::UnknownOperationError.new
      }
    end

    def process!
      processor_for(record.klass, operation_class).new(record, operation_date).call
    end

  private

    def processor_for(record_class, operation_class)
      operation_override_class = "TaricImporter::RecordProcessor::#{record_class}#{operation_class.to_s.demodulize}"
      if Object.const_defined?(operation_override_class)
        operation_override_class.constantize
      else
        operation_class
      end
    end
  end
end
