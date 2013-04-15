require 'tariff_importer/importers/taric_importer/helpers/string_helper'

class TaricImporter
  class RecordProcessor
    include TaricImporter::Helpers::StringHelper

    # If certain models need to be processed out in a different way
    # (see #default_process) this is a the place for these overrides, e.g.:
    #
    #  Language: {
    #    create: ->(attributes) {
    #      Language.insert(attributes)
    #    }
    #  }
    #
    # NOTE: in case of :create and :updates must return instance of model as
    #       it is going to be validated. :destroy returns nil, because we do not
    #       want to be validating non existant records.
    # NOTE: takes one argument: the arguments.
    #
    # Can also mutate attributes for all record operations, e.g.:
    #
    #  Language: {
    #    attributes: ->(attributes) {
    #      attributes[:a] = 'b'
    #      attributes   # do not forget to return it
    #    }
    #  }
    cattr_accessor :processor_overrides
    self.processor_overrides = {
      Measure: {
        # Avoid naming conflicts with associations.
        attributes: ->(attributes) {
          attributes['measure_type_id'] = attributes.delete('measure_type')
          attributes['additional_code_id'] = attributes.delete('additional_code')
          attributes['geographical_area_id'] = attributes.delete('geographical_area')
          attributes['additional_code_type_id'] = attributes.delete('additional_code_type')
          attributes
        }
      },
      GoodsNomenclature: {
        update: ->(record) {
          goods_nomenclature = record.klass.filter(record.attributes.slice(*record.primary_key).symbolize_keys).first
          goods_nomenclature.set(record.attributes.except(*record.primary_key).symbolize_keys)
          goods_nomenclature.save

          ::Measure.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                 .national
                 .non_invalidated.each do |measure|
            unless measure.valid?
              measure.invalidated_by = record.transaction_id
              measure.invalidated_at = Time.now
              measure.save(validate: false)
            end
          end

          goods_nomenclature
        },
        destroy: ->(record) {
          goods_nomenclature = record.klass.filter(record.attributes.slice(*record.primary_key).symbolize_keys).first
          goods_nomenclature.set(record.attributes.except(*record.primary_key).symbolize_keys)
          goods_nomenclature.destroy
          ::Measure.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                 .national
                 .non_invalidated.each do |measure|
            if measure.goods_nomenclature.blank?
              measure.invalidated_by = record.transaction_id
              measure.invalidated_at = Time.now
              measure.save(validate: false)
            end
          end

          nil
        }
      }
    }

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
                     ActiveSupport::Notifications.instrument("taric_unexpected_update_type.tariff_importer", record: record)

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
        model.save(validate: false) # defer validation, as associated
                                    # records in the same transaction
                                    # may not been saved yet
        model
      when :destroy
        model = klass.filter(attributes.slice(*primary_key).symbolize_keys).first
        model.set(attributes.except(*primary_key).symbolize_keys)
        model.destroy
        nil
      when :update
        model = klass.filter(attributes.slice(*primary_key).symbolize_keys).first
        model.set(attributes.except(*primary_key).symbolize_keys)
        model.save(validate: false)
        model
      end
    end

    def processor_for(klass, operation)
      class_override_present?(klass) &&
        self.class.processor_overrides[klass.name.to_sym][operation]
    end

    def attributes_for(klass)
      class_override_present?(klass) &&
        self.class.processor_overrides[klass.name.to_sym][:attributes]
    end

    def class_override_present?(klass)
      self.class.processor_overrides[klass.name.to_sym]
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
