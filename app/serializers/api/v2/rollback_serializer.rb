module Api
  module V2
    class RollbackSerializer
      include FastJsonapi::ObjectSerializer

      set_type :rollback

      set_id :id

      attributes :user_id, :reason, :date, :keep, :enqueued_at

      def serialized_errors
        errors = @resource.errors.flat_map do |attribute, error|
          { title: attribute, detail: error }
        end
        { data: { errors: errors } }
      end
    end
  end
end
