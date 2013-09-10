class CertificateDescription < Sequel::Model
  plugin :oplog, primary_key: [:certificate_description_period_sid]
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:certificate_description_period_sid]

  def to_s
    description
  end
end


