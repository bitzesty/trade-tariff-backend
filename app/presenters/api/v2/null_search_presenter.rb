module Api
  module V2
    class NullSearchPresenter
      attr_reader :result
  
      def initialize(result)
        @result = result
      end
  
      def id
        1
      end
  
      def type
        'null_match'
      end
  
      def goods_nomenclature_match
        result.serializable_hash[:goods_nomenclature_match]
      end
  
      def reference_match
        result.serializable_hash[:reference_match]
      end
    end
  end
end