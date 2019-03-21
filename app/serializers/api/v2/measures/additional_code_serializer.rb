module Api
  module V1
    module Measures
      class AdditionalCodeSerializer
        include FastJsonapi::ObjectSerializer
        set_id :additional_code_sid
        set_type :additional_code
        attributes :code, :description, :formatted_description
      end
    end
  end
end