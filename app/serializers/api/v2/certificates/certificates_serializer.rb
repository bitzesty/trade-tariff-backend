module Api
  module V2
    module Certificates
      class CertificatesSerializer
        include JSONAPI::Serializer

        set_id :id
        set_type :certificate

        attributes :certificate_type_code, :certificate_code, :description, :formatted_description

        has_many :measures, serializer: Api::V2::Certificates::MeasureSerializer
      end
    end
  end
end
