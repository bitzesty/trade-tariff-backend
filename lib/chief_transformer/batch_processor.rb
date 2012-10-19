class ChiefTransformer
  class BatchProcessor
    attr_reader :operations, :operator_name

    def initialize(operator_name, *operations)
      @operator_name = operator_name
      @operations = operations.flatten.sort_by(&:audit_tsmp)
    end

    def process
      Sequel::Model.db.transaction do
        begin
          operator_for(operator_name).new(operations, false).process
        rescue Exception => e
          raise ChiefTransformer::TransformException.new("Exception: \n #{e}. Backtrace: \n #{e.backtrace.join("\n")}")
        end
      end
    end

    private

    def operator_for(operator_name)
      "ChiefTransformer::Processor::#{operator_name}".constantize
    end
  end
end
