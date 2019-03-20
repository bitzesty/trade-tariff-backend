module Api
  module V1
    module Quotas
      class QuotaOrderNumberSerializer
        include FastJsonapi::ObjectSerializer
        set_id :quota_order_number_id
        set_type :order_number
        has_one :definition, serializer: Api::V1::Quotas::QuotaDefinitionSerializer
      end
    end
  end
end