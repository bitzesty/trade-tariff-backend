class FootnoteAssociationAdditionalCode < Sequel::Model
  set_primary_key [:footnote_id, :footnote_type_id, :additional_code_sid]
end


