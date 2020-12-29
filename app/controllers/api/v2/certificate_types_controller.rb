module Api
  module V2
    class CertificateTypesController < BaseController
      def index
        render json: Api::V2::Certificates::CertificateTypeSerializer.new(certificate_types, {}).serializable_hash
      end

      private

      def certificate_types
        CertificateType.all
      end
    end
  end
end
