module Api
  module V2
    module AdditionalCodes
      class AdditionalCodeTypeSerializer
        include FastJsonapi::ObjectSerializer

        set_type :additional_code_type

        set_id :additional_code_type_id

        attributes :additional_code_type_id, :description
      end
    end
  end
end