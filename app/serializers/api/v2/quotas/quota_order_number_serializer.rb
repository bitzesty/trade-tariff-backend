module Api
  module V2
    module Quotas
      class QuotaOrderNumberSerializer
        include FastJsonapi::ObjectSerializer

        set_type :order_number

        set_id :quota_order_number_id

        attribute :number do |quota|
          quota.quota_order_number_id
        end
        has_one :definition, serializer: Api::V2::Quotas::QuotaDefinitionSerializer
      end
    end
  end
end
