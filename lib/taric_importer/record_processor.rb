require 'forwardable'
require 'taric_importer/helpers/string_helper'

class TaricImporter < TariffImporter
  class RecordProcessor
    extend Forwardable

    include TaricImporter::Helpers::StringHelper

    def_delegator ActiveSupport::Notifications, :instrument

    # Meta record, containing all information from TARIC record as Hash
    attr_accessor :record

    # Operation: :create, :update, :destroy
    attr_accessor :operation

    # Entity class, e.g. Measure
    attr_accessor :klass

    # Entity primary key, i.e. Measure.primary_key
    attr_accessor :primary_key

    # TARIC transaction ID
    attr_accessor :transaction_id

    # The date of the update. NB not necessarily the current date.
    attr_accessor :operation_date

    # Sanitized and processed attributes
    attr_reader :attributes

    def initialize(record, operation_date = nil)
      self.operation_date = operation_date
      self.record = record
    end

    def record=(record)
      @record = record

      self.operation = record['update.type']
      self.transaction_id = record['transaction.id']
      self.klass = as_strategy(record.keys.last).constantize
      self.primary_key = [klass.primary_key].flatten.map(&:to_s)
      self.attributes = sanitize(record.values.last)
    end

    def attributes=(attributes)
      attributes = if attribute_processor = attributes_for(klass)
                     attribute_processor.call(attributes)
                   else
                     attributes
                   end

      @attributes = default_attributes.merge(attributes)
    end

    def default_attributes
      klass.columns.inject({}) { |memo, column_name|
        memo.merge!(Hash[column_name.to_s, nil])
        memo
      }
    end

    def operation=(operation)
      @operation = case operation
                   when "1" then :update
                   when "2" then :destroy
                   when "3" then :create
                   else
                     instrument("taric_unexpected_update_type.tariff_importer", record: record)

                     raise TaricImporter::ImportException.new
                   end
    end

    def process!
      if processor_override = processor_for(klass, operation)
        processor_override.call(self)
      else
        default_process
      end
    end

    private

    def default_process
      case operation
      when :create
        model = klass.new(attributes)
        instrument("conformance_error.taric_importer", record: model) unless model.conformant_for?(:create)
        model.save(validate: false)
        model
      when :destroy
        model = klass.filter(attributes.slice(*primary_key).symbolize_keys).first
        model.set(attributes.except(*primary_key).symbolize_keys)
        instrument("conformance_error.taric_importer", record: model) unless model.conformant_for?(:destroy)
        model.destroy
        nil
      when :update
        model = klass.filter(attributes.slice(*primary_key).symbolize_keys).first
        model.set(attributes.except(*primary_key).symbolize_keys)
        instrument("conformance_error.taric_importer", record: model) unless model.conformant_for?(:update)
        model.save(validate: false)
        model
      end
    end

    def processor_for(klass, operation)
      class_override_present?(klass) &&
        TaricImporter::PROCESSOR_OVERRIDES[klass.name.to_sym][operation]
    end

    def attributes_for(klass)
      class_override_present?(klass) &&
        TaricImporter::PROCESSOR_OVERRIDES[klass.name.to_sym][:attributes]
    end

    def class_override_present?(klass)
      TaricImporter::PROCESSOR_OVERRIDES[klass.name.to_sym]
    end

    def sanitize(attributes)
      attributes.inject({}) { |memo, (key, value)|
        memo.merge!(Hash[as_param(key), value.strip]) unless value.blank?
        memo
      }.merge('operation' => operation,
              'operation_date' => operation_date)
    end
  end
end
