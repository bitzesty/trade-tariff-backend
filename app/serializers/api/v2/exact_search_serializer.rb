module Api
  module V2
    class ExactSearchSerializer
      include FastJsonapi::ObjectSerializer

      set_type :exact_search
      
      attributes :type, :entry
    end
  end
end