class TaricImporter
  module Strategies
    class BaseStrategy
      include TaricImporter::Helpers::StringHelper

      attr_accessor :xml, :operation, :processor, :attributes, :record_attributes

      def initialize(xml)
        self.xml = xml
        self.operation = xml.xpath("record/update.type").text
        self.attributes = xml.xpath("record/update.type/following-sibling::*").first.children
        self.record_attributes = {
          record_code: xml.xpath("record/record.code").text,
          subrecord_code: xml.xpath("record/subrecord.code").text,
          record_sequence_number: xml.xpath("record/record.sequence.number").text
        }
      end

      def attributes=(attributes)
        @attributes ||= attributes.inject({}) { |memo, key|
                          memo.merge!(Hash[as_param(key.name), key.text.strip]) unless key.text.strip.blank?
                          memo
                        }
      end

      def operation=(operation)
        @operation = case operation
                     when "1" then :update
                     when "2" then :delete
                     when "3" then :insert
                     else
                       ActiveSupport::Notifications.instrument("taric_unexpected_update_type.tariff_importer", xml: xml)
                     end
      end

      def processors; self.class.processors; end

      def process!
        # execute either defined or default strategy process action
        if processors.has_key?(operation) &&
           processors[operation].is_a?(Proc)
          instance_eval(&processors[operation])
        else
          default_process
        end

        self
      end

      private

      def default_process
        klass = "::#{self.class.name.demodulize}".constantize
        primary_key = [klass.primary_key].flatten.map(&:to_s)

        case operation
        when :insert
          klass.model.insert(self.attributes)
        when :delete
          klass.db[klass.table_name].filter(self.attributes.slice(*primary_key).symbolize_keys).delete
        when :update
          klass.db[klass.table_name].filter(self.attributes.slice(*primary_key).symbolize_keys)
                                    .update(self.attributes.symbolize_keys)
        end
      end

      # Used to support DSL declarations in strategies
      class << self
        def processors
          @processors ||= {}
        end

        def process(operation, &block)
          @processors ||= {}
          @processors.deep_merge!(Hash[operation, block]) if block_given?
        end
      end
    end
  end
end
