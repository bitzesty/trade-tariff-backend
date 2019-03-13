module Api
  module V1
    module Changes
      class ChangeSerializer
        include FastJsonapi::ObjectSerializer
        set_id :oid
        set_type :change
        attributes :oid, :model_name, :operation, :operation_date
        has_one :record, polymorphic: true

      end
    end
  end
end
