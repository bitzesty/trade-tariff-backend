module Api
  module V2
    module Certificates
      class CertificateTypeSerializer
        include JSONAPI::Serializer

        set_type :certificate_type

        set_id :certificate_type_code

        attributes :certificate_type_code, :description
      end
    end
  end
end
