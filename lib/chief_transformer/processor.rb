Dir[File.join(Rails.root, 'lib', 'chief_transformer/interactions/*.rb')].each{|f| require f }

class ChiefTransformer
  class Processor
    attr_reader :operations

    def initialize(*operations)
      @operations = operations.flatten.sort_by(&:audit_tsmp)
    end

    def process
      operations.each do |operation|
        operator_for(operation).new(operation).process
      end
    end

    private

    def operator_for(operation)
      ["ChiefTransformer::Processor",
       operation_name(operation)].join("::").constantize
    end

    def operation_name(operation)
      operation.class.name.demodulize.tap!{|name|
        name << case operation.amend_indicator
                when "I"
                  "Insert"
                when "X"
                  "Delete"
                when "U"
                  "Update"
                end
      }
    end
  end
end
