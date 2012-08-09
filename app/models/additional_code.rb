class AdditionalCode < Sequel::Model
  plugin :time_machine

  set_primary_key :additional_code_sid

  one_to_one :additional_code_description, eager_loader_key: :additional_code_sid, dataset: -> {
    AdditionalCodeDescription.with_actual(AdditionalCodeDescriptionPeriod)
                             .join(:additional_code_description_periods, additional_code_description_periods__additional_code_description_period_sid: :additional_code_descriptions__additional_code_description_period_sid,
                                                                         additional_code_description_periods__additional_code_sid: :additional_code_descriptions__additional_code_sid)
                             .where(additional_code_descriptions__additional_code_sid: additional_code_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|additional_code| additional_code.associations[:additional_code_description] = nil}

    id_map = eo[:id_map]

    AdditionalCodeDescription.with_actual(AdditionalCodeDescriptionPeriod)
                             .join(:additional_code_description_periods, additional_code_description_periods__additional_code_description_period_sid: :additional_code_descriptions__additional_code_description_period_sid,
                                                                         additional_code_description_periods__additional_code_sid: :additional_code_descriptions__additional_code_sid)
                             .where(additional_code_descriptions__additional_code_sid: id_map.keys).all do |additional_code_description|
      if additional_codes = id_map[additional_code_description.additional_code_sid]
        additional_codes.each do |additional_code|
          additional_code.associations[:additional_code_description] = additional_code_description
        end
      end
    end
  end)

  delegate :description, to: :additional_code_description

  def code
    "#{additional_code_type_id}#{additional_code}"
  end
end


