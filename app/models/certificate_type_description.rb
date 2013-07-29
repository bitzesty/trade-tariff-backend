class CertificateTypeDescription < Sequel::Model
  plugin :oplog, primary_key: :certificate_type_code
  plugin :conformance_validator

  set_primary_key [:certificate_type_code]
end


