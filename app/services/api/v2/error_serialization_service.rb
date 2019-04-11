module Api
  module V2
    class ErrorSerializationService
      def serialized_errors(errors)
        errors = Array.wrap(errors).map do |error|
          if error.has_key?(:error)
            { detail: error[:error] }
          else
            error.flat_map do |attribute, error|
              { title: attribute, detail: error }
            end
          end
        end
        { errors: errors }.to_json
      end
    end
  end
end