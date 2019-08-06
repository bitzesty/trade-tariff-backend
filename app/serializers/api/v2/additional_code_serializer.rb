module Api
  module V2
    class AdditionalCodeSerializer
      include FastJsonapi::ObjectSerializer

      set_type :additional_code

      set_id :additional_code_sid

      attributes :code, :description, :formatted_description
    end
  end
end
