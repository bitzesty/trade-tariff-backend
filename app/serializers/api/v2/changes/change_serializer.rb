module Api
  module V2
    module Changes
      class ChangeSerializer
        include JSONAPI::Serializer

        set_type :change

        set_id :oid

        attributes :oid, :model_name, :operation, :operation_date

        has_one :record, polymorphic: true
      end
    end
  end
end
