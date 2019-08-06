module Api
  module V2
    class CertificatesController < ApiController
      before_action :find_certificates

      def search
        options = {}
        options[:include] = [:measures, 'measures.goods_nomenclature']
        render json: Api::V2::Certificates::CertificatesSerializer.new(@certificates, options).serializable_hash
      end

      private

      def find_certificates
        TimeMachine.now do
          @certificates = CertificateSearchService.new(params).perform
        end
      end
    end
  end
end
