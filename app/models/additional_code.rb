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


  ######### Conformance validations 245
  def validate
    super
    # ACN1
    validates_unique([:additional_code, :additional_code_type_id, :validity_start_date])
    # TODO: ACN2
    # ACN3
    validates_start_date
    # TODO: ACN4
    # TODO: ACN12
    # TODO: ACN13
    # TODO: ACN17
    # TODO: ACN6
    # TODO: ACN7
    # TODO: ACN8
    # TODO: ACN9
    # TODO: ACN10
    # TODO: ACN11
    # TODO: ACN16
    # TODO: ACN5
    # TODO: ACN14
    # TODO: ACN15
  end
end


