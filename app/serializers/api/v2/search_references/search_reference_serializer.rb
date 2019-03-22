module Api
  module V2
    module SearchReferences
      class SearchReferenceSerializer
        include FastJsonapi::ObjectSerializer
        set_type :search_reference
        set_id :id
        
        attributes :title, :referenced_id, :referenced_class
        
        has_one :referenced, polymorphic: true
      end
    end
  end
end