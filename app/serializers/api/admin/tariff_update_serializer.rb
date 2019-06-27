module Api
  module Admin
    class TariffUpdateSerializer
      include FastJsonapi::ObjectSerializer

      set_type :tariff_update

      set_id :filename

      attributes :update_type, :state, :created_at, :updated_at, :filename, :applied_at, :filesize, :exception_backtrace,
                 :exception_queries, :exception_class, :file_presigned_url, :log_presigned_urls

      has_many :conformance_errors, serializer: Api::V2::ConformanceErrorSerializer
      has_many :presence_errors, serializer: Api::V2::PresenceErrorSerializer
    end
  end
end
