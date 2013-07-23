class LanguageDescription < Sequel::Model
  plugin :oplog, primary_key: [:language_id, :language_code_id]
  plugin :conformance_validator

  set_primary_key  [:language_id, :language_code_id]
end


