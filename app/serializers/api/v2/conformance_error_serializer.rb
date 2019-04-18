module Api
  module V2
    class ConformanceErrorSerializer
      include FastJsonapi::ObjectSerializer

      set_type :conformance_error

      set_id :id

      attributes :model_name, :model_primary_key, :model_values, :model_conformance_errors
    end
  end
end
