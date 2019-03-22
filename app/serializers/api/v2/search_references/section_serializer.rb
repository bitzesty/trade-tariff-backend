module Api
  module V2
    module SearchReferences
      class SectionSerializer
        include FastJsonapi::ObjectSerializer
        set_type :section
        
        attributes :numeral, :title, :position
        
      end
    end
  end
end