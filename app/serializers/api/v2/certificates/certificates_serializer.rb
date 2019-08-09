module Api
  module V2
    module Certificates
      class CertificatesSerializer
        include FastJsonapi::ObjectSerializer

        set_id :id

        attributes :certificate_type_code, :certificate_code, :description

        has_many :measures, serializer: Api::V2::Certificates::MeasureSerializer
      end
    end
  end
end