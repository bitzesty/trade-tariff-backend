class FootnoteAssociationMeursingHeading < Sequel::Model
  plugin :oplog, primary_key: %i[measure_sid
                                 footnote_id
                                 meursing_table_plan_id]
  plugin :conformance_validator

  set_primary_key %i[footnote_id meursing_table_plan_id]
end
