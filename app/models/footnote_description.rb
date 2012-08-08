class FootnoteDescription < Sequel::Model
  plugin :time_machine

  set_primary_key :footnote_id, :footnote_type_id
end


