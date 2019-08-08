module Api
  module V2
    module AdditionalCodes
      class AdditionalCodeSerializer
        include FastJsonapi::ObjectSerializer

        set_type :additional_code

        set_id :additional_code_sid

        attributes :code, :description, :formatted_description

        has_many :measures, object_method_name: :valid_measures, serializer: Api::V2::AdditionalCodes::MeasureSerializer
      end
    end
  end
end
