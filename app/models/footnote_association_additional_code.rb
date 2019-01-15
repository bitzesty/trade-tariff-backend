class FootnoteAssociationAdditionalCode < Sequel::Model
  plugin :oplog, primary_key: %i[footnote_id
                                 footnote_type_id
                                 additional_code_sid]
  plugin :conformance_validator
  set_primary_key %i[footnote_id footnote_type_id additional_code_sid]
end
