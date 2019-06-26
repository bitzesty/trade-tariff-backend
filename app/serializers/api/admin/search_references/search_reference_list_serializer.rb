module Api
  module Admin
    module SearchReferences
      class SearchReferenceListSerializer
        include FastJsonapi::ObjectSerializer

        set_type :search_reference

        set_id :id
  
        attributes :title, :referenced_id, :referenced_class
      end
    end
  end
end
