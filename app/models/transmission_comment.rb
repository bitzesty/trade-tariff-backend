class TransmissionComment < Sequel::Model
  plugin :oplog, primary_key: [:comment_sid, :language_id]
  plugin :conformance_validator

  set_primary_key [:comment_sid, :language_id]

  many_to_one :language
end


