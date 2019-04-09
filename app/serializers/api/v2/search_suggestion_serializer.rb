module Api
  module V2
    class SearchSuggestionSerializer
      include FastJsonapi::ObjectSerializer

      set_type :search_suggestion
      
      attribute :value
    end
  end
end