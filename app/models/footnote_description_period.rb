class FootnoteDescriptionPeriod < Sequel::Model
  plugin :time_machine

  set_primary_key :footnote_id, :footnote_type_id, :footnote_description_period_sid

  one_to_one :footnote_description, key: [:footnote_id, :footnote_type_id,
                                          :footnote_description_period_sid]

  # belongs_to :footnote_type
  # belongs_to :footnote, foreign_key: [:footnote_id, :footnote_type_id]
  # belongs_to :footnote_description, foreign_key: [:footnote_id,
  #                                                 :footnote_type_id,
  #                                                 :footnote_description_period_sid]
end


