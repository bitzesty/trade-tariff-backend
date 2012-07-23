class AdditionalCode < Sequel::Model
  plugin :time_machine

  set_primary_key :additional_code_sid

  one_to_one :additional_code_description, dataset: -> {
    AdditionalCodeDescription.with_actual(AdditionalCodeDescriptionPeriod)
                             .join(:additional_code_description_periods, additional_code_description_periods__additional_code_description_period_sid: :additional_code_descriptions__additional_code_description_period_sid,
                                                                         additional_code_description_periods__additional_code_sid: :additional_code_descriptions__additional_code_sid)
                             .where(additional_code_descriptions__additional_code_sid: additional_code_sid)
  }

  delegate :description, to: :additional_code_description

  def code
    "#{additional_code_type_id}#{additional_code_id}"
  end

  # one_to_many :additional_code_description_periods, left_primary_key: :additional_code_sid,  key: [:additional_code_description_period_sid, :additional_code_sid, :additional_code_type_id]
  # one_to_many :additional_code_descriptions, join_table: :additional_code_description_periods,
  #                                         key: [:additional_code_description_period_sid, :additional_code_sid]
  # one_to_many :footnote_association_additional_codes, key: :additional_code_sid
  # one_to_many :footnotes, join_table: :footnote_association_additional_codes

  # one_to_one :measure, key: :additional_code_sid

  # many_to_one :additional_code_type, key: :additional_code_type_id
end


