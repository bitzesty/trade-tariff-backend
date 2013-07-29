class FootnoteTypeDescription < Sequel::Model
  plugin :oplog, primary_key: :footnote_type_id
  plugin :conformance_validator

  set_primary_key [:footnote_type_id]
end


