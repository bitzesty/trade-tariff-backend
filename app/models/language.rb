class Language < Sequel::Model
  plugin :oplog, primary_key: :language_id
  plugin :conformance_validator

  set_primary_key [:language_id]
end


