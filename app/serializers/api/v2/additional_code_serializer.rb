module Api
  module V2
    class AdditionalCodeSerializer
      include JSONAPI::Serializer

      set_type :additional_code

      set_id :additional_code_sid

      attributes :code, :description, :formatted_description
    end
  end
end
