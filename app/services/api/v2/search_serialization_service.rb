module Api
  module V2
    class SearchSerializationService
    
      def perform(result)
        clazz = result.class.name.split('::').last
        presenter = "Api::V2::#{clazz}Presenter".constantize.new(result)
        "Api::V2::#{clazz}Serializer".constantize.new(presenter).serializable_hash
      end
    
    end
  end
end