module Api
  module V2
    class TariffUpdateSerializer
      include FastJsonapi::ObjectSerializer

      set_type :tariff_update

      set_id :filename

      attributes :update_type, :state, :created_at, :updated_at, :filename, :applied_at
    end
  end
end
