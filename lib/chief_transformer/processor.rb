Dir[File.join(Rails.root, 'lib', 'chief_transformer/operations/*.rb')].each{|f| require f }

class ChiefTransformer
  class Processor
    attr_reader :operations

    def initialize(*operations)
      @operations = operations.flatten.sort_by(&:audit_tsmp)
    end

    def process
      operations.each do |operation|
        ActiveSupport::Notifications.instrument("process.chief_transformer", operation: operation) do
          Sequel::Model.db.transaction do
            begin
              operator_for(operation).new(operation).process

              operation.mark_as_processed!
            rescue Exception => e
              raise ChiefTransformer::TransformException.new("Could not transform: #{operation.inspect}. \n #{e} \nBacktrace: \n#{e.backtrace.join("\n")}")
            end
          end
        end
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
                else
                  "Insert"
                end
      }
    end
  end
end
