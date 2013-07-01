class CertificateDescription < Sequel::Model
  plugin :oplog, primary_key: [:certificate_description_period_sid]
  plugin :time_machine

  set_primary_key [:certificate_description_period_sid]
end


