require 'formatter'

class FootnoteDescription < Sequel::Model
  include Formatter

  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_description_period_sid,
                               :footnote_id,
                               :footnote_type_id]
  plugin :conformance_validator

  set_primary_key [:footnote_description_period_sid, :footnote_id, :footnote_type_id]

  format :formatted_description, with: DescriptionFormatter,
                                 using: :description
end
