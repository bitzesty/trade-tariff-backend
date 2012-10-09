class Measure < Sequel::Model
  set_primary_key :measure_sid
  plugin :time_machine, period_start_column: :effective_start_date,
                        period_end_column: :effective_end_date

  plugin :national
  plugin :timestamps

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid,
                                   foreign_key: :goods_nomenclature_sid

  many_to_one :export_refund_nomenclature, key: :export_refund_nomenclature_sid,
                                   foreign_key: :export_refund_nomenclature_sid

  many_to_one :measure_type, key: :measure_type_id, dataset: -> {
    actual(MeasureType).where(measure_type_id: self[:measure_type])
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:measure_type] = nil}

    id_map = eo[:id_map]

    MeasureType.actual
               .eager(:measure_type_description)
               .where(measure_type_id: id_map.keys)
               .all do |measure_type|
      if measures = id_map[measure_type.measure_type_id]
        measures.each do |measure|
          measure.associations[:measure_type] = measure_type
        end
      end
    end
  end)

  one_to_many :measure_conditions, key: :measure_sid, dataset: -> {
    MeasureCondition.where(measure_sid: measure_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:measure_conditions] = []}

    id_map = eo[:id_map]

    MeasureCondition.eager({certificate: :certificate_description},
                           {certificate_type: :certificate_type_description},
                           {measurement_unit: :measurement_unit_description},
                           :monetary_unit,
                           :measure_condition_code,
                           :measure_condition_components,
                           :measure_action,
                           :measurement_unit_qualifier)
                    .where(measure_conditions__measure_sid: id_map.keys).all do |measure_condition|
      if measures = id_map[measure_condition.measure_sid]
        measures.each do |measure|
          measure.associations[:measure_conditions] << measure_condition
        end
      end
    end
  end)

  one_to_one :geographical_area, key: :geographical_area_sid, eager_loader_key: :geographical_area_sid, dataset: -> {
    actual(GeographicalArea).where(geographical_area_sid: geographical_area_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:geographical_area] = nil}

    id_map = eo[:id_map]

    GeographicalArea.actual
                    .eager(:geographical_area_description,
                           :contained_geographical_areas)
                    .where(geographical_area_sid: id_map.keys)
                    .all do |geographical_area|
      if measures = id_map[geographical_area.geographical_area_sid]
        measures.each do |measure|
          measure.associations[:geographical_area] = geographical_area
        end
      end
    end
  end)


  many_to_many :excluded_geographical_areas, join_table: :measure_excluded_geographical_areas,
                                             left_key: :measure_sid,
                                             left_primary_key: :measure_sid,
                                             right_key: :excluded_geographical_area,
                                             right_primary_key: :geographical_area_id,
                                             class_name: 'GeographicalArea'

  many_to_many :footnotes, dataset: -> {
    actual(Footnote)
            .join(:footnote_association_measures, footnote_id: :footnote_id, footnote_type_id: :footnote_type_id)
            .where("footnote_association_measures.measure_sid = ?", measure_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:footnotes] = []}

    id_map = eo[:id_map]

    Footnote.actual
            .eager(:footnote_description)
            .join(:footnote_association_measures, footnote_id: :footnote_id, footnote_type_id: :footnote_type_id)
            .where(footnote_association_measures__measure_sid: id_map.keys).all do |footnote|
      if measures = id_map[footnote[:measure_sid]]
        measures.each do |measure|
          measure.associations[:footnotes] << footnote
        end
      end
    end
  end)

  one_to_many :footnote_association_measures, key: :measure_sid, primary_key: :measure_sid

  one_to_many :measure_components, key: :measure_sid, dataset: -> {
    MeasureComponent.where(measure_sid: measure_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:measure_components] = []}

    id_map = eo[:id_map]

    MeasureComponent.eager(:duty_expression,
                           :measurement_unit,
                           :monetary_unit,
                           :measurement_unit_qualifier)
                    .where(measure_sid: id_map.keys).all do |measure_component|
      if measures = id_map[measure_component.measure_sid]
        measures.each do |measure|
          measure.associations[:measure_components] << measure_component
        end
      end
    end
  end)

  many_to_one :additional_code, key: :additional_code_sid, eager_loader_key: :additional_code_sid,
    dataset: -> {
      actual(AdditionalCode).where(additional_code_sid: additional_code_sid)
    }, eager_loader: (proc do |eo|
      eo[:rows].each{|measure| measure.associations[:additional_code] = nil}

      id_map = eo[:id_map]

      AdditionalCode.actual
                    .eager(:additional_code_description)
                    .where(additional_code_sid: id_map.keys).all do |additional_code|
        if measures = id_map[additional_code.additional_code_sid]
          measures.each do |measure|
            measure.associations[:additional_code] = additional_code
          end
        end
      end
    end)

  one_to_one :quota_order_number, eager_loader_key: :ordernumber, dataset: -> {
    actual(QuotaOrderNumber).where(quota_order_number_id: ordernumber)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:quota_order_number] = nil}

    id_map = eo[:id_map]

    QuotaOrderNumber.actual
                    .eager(:quota_definition)
                    .where(quota_order_number_id: id_map.keys).all do |order_number|
      if measures = id_map[order_number.quota_order_number_id]
        measures.each do |measure|
          measure.associations[:quota_order_number] = order_number
        end
      end
    end
  end)

  one_to_one :full_temporary_stop_regulation, key: {}, primary_key: {}, eager_loader_key: :measure_generating_regulation_id, dataset: -> {
    FullTemporaryStopRegulation.actual
                               .join(FtsRegulationAction, full_temporary_stop_regulations__full_temporary_stop_regulation_id: :fts_regulation_actions__fts_regulation_id)
                               .where(fts_regulation_actions__stopped_regulation_id: measure_generating_regulation_id)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:full_temporary_stop_regulation] = nil}

    id_map = eo[:id_map]

    FullTemporaryStopRegulation.actual
                               .join(FtsRegulationAction, full_temporary_stop_regulations__full_temporary_stop_regulation_id: :fts_regulation_actions__fts_regulation_id)
                               .where(fts_regulation_actions__stopped_regulation_id: id_map.keys).all do |fts_regulation|
      if measures = id_map[fts_regulation[:stopped_regulation_id]]
        measures.each do |measure|
          measure.associations[:full_temporary_stop_regulation] = fts_regulation
        end
      end
    end
  end)

  one_to_one :measure_partial_temporary_stop, key: {}, primary_key: {}, eager_loader_key: :measure_generating_regulation_id, dataset: -> {
    MeasurePartialTemporaryStop.actual
                               .where(measure_partial_temporary_stops__partial_temporary_stop_regulation_id: measure_generating_regulation_id)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:measure_partial_temporary_stop] = nil}

    id_map = eo[:id_map]

    MeasurePartialTemporaryStop.actual
                               .where(measure_partial_temporary_stops__partial_temporary_stop_regulation_id: id_map.keys).all do |stopped_regulation|
      if measures = id_map[stopped_regulation[:partial_temporary_stop_regulation_id]]
        measures.each do |measure|
          measure.associations[:measure_partial_temporary_stop] = stopped_regulation
        end
      end
    end
  end)

  def_column_alias :measure_type_id, :measure_type
  def_column_alias :additional_code_id, :additional_code
  def_column_alias :geographical_area_id, :geographical_area

  ######### Conformance validations 430
  def validate
    super
    # ME1
    # validates_unique([:measure_type, :geographical_area, :goods_nomenclature_sid, :additional_code_type, :additional_code, :ordernumber, :reduction_indicator, :validity_start_date])
    # ME2 ME4 ME6 ME24
    # validates_presence([:measure_type, :geographical_area, :goods_nomenclature_sid, :measure_generating_regulation_id, :measure_generating_regulation_role])
    # TODO: ME3
    # The validity period of the measure type must span the validity period of the measure.
    # TODO: ME5
    # The validity period of the geographical area must span the validity period of the measure.
    # TODO: ME7
    # The goods nomenclature code must be a product code; that is, it may not be an intermediate line.
    # TODO: ME8
    # The validity period of the goods code must span the validity period of the measure.
    # TODO: ME88
    # The level of the goods code, if present, cannot exceed the explosion level of the measure type.
    # TODO: ME16
    # Integrating a measure with an additional code when an equivalent or overlapping measures without additional code already exists and vice-versa, should be forbidden.
    # TODO: ME115
    # The validity period of the referenced additional code must span the validity period of the measure
    # ME25
    validates_start_date
    # TODO: ME32
    # There may be no overlap in time with other measure occurrences with a goods code in the same nomenclature hierarchy which references the same measure type, geo area, order number, additional code and reduction indicator. This rule is not applicable for Meursing additional codes.
    # TODO: ME10
    # The order number must be specified if the "order number flag" (specified in the measure type record) has the value "mandatory". If the flag is set to "not permitted" then the field cannot be entered.
    # TODO: ME116
    # When a quota order number is used in a measure then the validity period of the quota order number must span the validity period of the measure.  This rule is only applicable for measures with start date after 31/12/2007.
    # TODO: ME117
    # When a measure has a quota measure type then the origin must exist as a quota order number origin.  This rule is only applicable for measures with start date after 31/12/2007. Only origins for quota order numbers managed by the first come first served principle are in scope; these order number are starting with '09'; except order numbers starting with '094'
    # TODO: ME118
    # When a quota order number is used in a measure then the validity period of the quota order number must span the validity period of the measure.  This rule is only applicable for measures with start date after 31/12/2007. Only quota order numbers managed by the first come first served principle are in scope; these order number are starting with '09'; except order numbers starting with '094'
    # TODO: ME119
    # When a quota order number is used in a measure then the validity period of the quota order number origin must span the validity period of the measure.  This rule is only applicable for measures with start date after 31/12/2007. Only origins for quota order numbers managed by the first come first served principle are in scope; these order number are starting with '09'; except order numbers starting with '094'
    # TODO: ME9
    # If no additional code is specified then the goods code is mandatory.
    # TODO: ME12
    # If the additional code is specified then the additional code type must have a relationship with the measure type.
    # TODO: ME13
    # If the additional code type is related to a Meursing table plan then only the additional code can be specified: no goods code, order number or reduction indicator.
    # TODO: ME14
    # If the additional code type is related to a Meursing table plan then the additional code must exist as a Meursing additional code.
    # TODO: ME15
    # If the additional code type is related to a Meursing table plan then the validity period of the additional code must span the validity period of the measure.
    # TODO: ME17
    # If the additional code type has as application "non-Meursing" then the additional code must exist as a non-Meursing additional code.
    # TODO: ME18
    # If the additional code type has as application "non-Meursing" then the validity period of the non-Meursing additional code must span the validity period of the measure.
    # TODO: ME19
    # If the additional code type has as application "ERN" then the goods code must be specified but the order number is blocked for input.
    # TODO: ME21
    # If the additional code type has as application "ERN" then the combination of goods code + additional code must exist as an ERN product code and its validity period must span the validity period of the measure.
    # TODO: ME112
    # If the additional code type has as application "Export Refund for Processed Agricultural Goods" then the measure does not require a goods code.
    # TODO: ME113
    # If the additional code type has as application "Export Refund for Processed Agricultural Goods" then the additional code must exist as an Export Refund for Processed Agricultural Goods additional code.
    # TODO: ME114
    # If the additional code type has as application "Export Refund for Processed Agricultural Goods" then the validity period of the Export Refund for Processed Agricultural Goods additional code must span the validity period of the measure.
    # TODO: ME86
    # The role of the entered regulation must be a Base, a Modification, a Provisional Anti-Dumping, a Definitive Anti-Dumping.
    # TODO: ME87
    # The VP of the measure (implicit or explicit) must reside within the effective VP of its supporting regulation. The effective VP is the VP of the regulation taking into account extensions and abrogation.
    # TODO: ME26
    # The entered regulation may not be completely abrogated.
    # TODO: ME27
    # The entered regulation may not be fully replaced.
    # TODO: ME28
    # The entered regulation may not be partially replaced for the measure type, geographical area or chapter (first two digits of the goods code) of the measure.
    # TODO: ME29
    # If the entered regulation is a modification regulation then its base regulation may not be completely abrogated.
    # TODO: ME33
    # A justification regulation may not be entered if the measure end date is not filled in.
    # TODO: ME34
    # A justification regulation must be entered if the measure end date is filled in.
    # TODO: ME40
    # If the flag "duty expression" on measure type is "mandatory" then at least one measure component or measure condition component record must be specified. If the flag is set ""not permitted"" then no measure component or measure condition component must exist. Measure components and measure condition components are mutually exclusive. A measure can have either components or condition components (if the 'duty expression’ flag is 'mandatory’ or 'optional’) but not both.
    # TODO: ME41
    # The referenced duty expression must exist.
    # TODO: ME42
    # The validity period of the duty expression must span the validity period of the measure.
    # TODO: ME43
    # The same duty expression can only be used once with the same measure.
    # TODO: ME45
    # If the flag "amount" on duty expression is "mandatory" then an amount must be specified. If the flag is set "not permitted" then no amount may be entered.
    # TODO: ME46
    # If the flag "monetary unit" on duty expression is "mandatory" then a monetary unit must be specified. If the flag is set "not permitted" then no monetary unit may be entered.
    # TODO: ME47
    # If the flag "measurement unit" on duty expression is "mandatory" then a measurement unit must be specified. If the flag is set "not permitted" then no measurement unit may be entered.
    # TODO: ME48
    # The referenced monetary unit must exist.
    # TODO: ME49
    # The validity period of the referenced monetary unit must span the validity period of the measure.
    # TODO: ME50
    # The combination measurement unit + measurement unit qualifier must exist.
    # TODO: ME51
    # The validity period of the measurement unit must span the validity period of the measure.
    # TODO: ME52
    # The validity period of the measurement unit qualifier must span the validity period of the measure.
    # TODO: ME53
    # The referenced measure condition must exist.
    # TODO: ME54
    # The validity period of the referenced measure condition must span the validity period of the measure.
    # TODO: ME55
    # A measure condition refers to a measure condition or to a condition + certificate or to a condition + amount specifications.
    # TODO: ME56
    # The referenced certificate must exist.
    # TODO: ME57
    # The validity period of the referenced certificate must span the validity period of the measure.
    # TODO: ME58
    # The same certificate can only be referenced once by the same measure and the same condition type.
    # TODO: ME59
    # The referenced action code must exist.
    # TODO: ME60
    # The referenced monetary unit must exist.
    # TODO: ME61
    # The validity period of the referenced monetary unit must span the validity period of the measure.
    # TODO: ME62
    # The combination measurement unit + measurement unit qualifier must exist.
    # TODO: ME63
    # The validity period of the measurement unit must span the validity period of the measure.
    # TODO: ME64
    # The validity period of the measurement unit qualifier must span the validity period of the measure.
    # TODO: ME105
    # The referenced duty expression must exist.
    # TODO: ME106
    # The VP of the duty expression must span the VP of the measure.
    # TODO: ME107
    # If the short description of a duty expression starts with a '+' then a measure condition component with a preceding duty expression must exist (sequential ascending order) for a condition (at least one, not necessarily the same condition) of the same measure.
    # TODO: ME108
    # The same duty expression can only be used once within condition components of the same condition of the same measure. (i.e. it can be re-used in other conditions, no matter what condition type, of the same measure)
    # TODO: ME109
    # If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered.
    # TODO: ME110
    # If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified. If the flag is set to 'not permitted' then no monetary unit may be entered.
    # TODO: ME111
    # If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified. If the flag is set to 'not permitted' then no measurement unit may be entered.
    # TODO: ME65
    # An exclusion can only be entered if the measure is applicable to a geographical area group (area code = 1).
    # TODO: ME66
    # The excluded geographical area must be a member of the geographical area group.
    # TODO: ME67
    # The membership period of the excluded geographical area must span the validity period of the measure.
    # TODO: ME68
    # The same geographical area can only be excluded once by the same measure.
    # TODO: ME69
    # The associated footnote must exist.
    # TODO: ME70
    # The same footnote can only be associated once with the same measure.
    # TODO: ME71
    # Footnotes with a footnote type for which the application type = "CN footnotes" cannot be associated with TARIC codes (codes with pos. 9-10 different from 00)
    # TODO: ME72
    # Footnotes with a footnote type for which the application type = "measure footnotes" can be associated at any level.
    # TODO: ME73
    # The validity period of the associated footnote must span the validity period of the measure.
    # TODO: ME39
    # The validity period of the measure must span the validity period of all related partial temporary stop (PTS) records.
    # TODO: ME74
    # The start date of the PTS must be less than or equal to the end date.
    # TODO: ME75
    # The PTS regulation and abrogation regulation must be the same if the start date and the end date are entered when creating the record.
    # TODO: ME76
    # The abrogation regulation may not be entered if the PTS end date is not filled in.
    # TODO: ME77
    # The abrogation regulation must be entered if the PTS end date is filled in.
    # TODO: ME78
    # The abrogation regulation must be different from the PTS regulation if the end date is filled in during a modification.
    # TODO: ME79
    # There may be no overlap between different PTS periods.
    # TODO: ME104
    # The justification regulation must be either: - the measure's measure-generating regulation, or - a measure-generating regulation, valid on the day after the measure’s (explicit) end date. If the measure’s measure-generating regulation is 'approved’, then so must be the justification regulation.
  end

  dataset_module do
    def with_base_regulations
      select(:measures.*).
      select_append(Sequel.as(:if.sql_function('measures.validity_start_date IS NOT NULL'.lit, 'measures.validity_start_date'.lit, 'base_regulations.validity_start_date'.lit), :effective_start_date)).
      select_append(Sequel.as(:if.sql_function('measures.validity_end_date IS NOT NULL'.lit, 'measures.validity_end_date'.lit, 'base_regulations.effective_end_date'.lit), :effective_end_date)).
      join_table(:right, :base_regulations, base_regulations__base_regulation_id: :measures__measure_generating_regulation_id)
    end

    def with_modification_regulations
      select(:measures.*).
      select_append(Sequel.as(:if.sql_function('measures.validity_start_date IS NOT NULL'.lit, 'measures.validity_start_date'.lit, 'modification_regulations.validity_start_date'.lit), :effective_start_date)).
      select_append(Sequel.as(:if.sql_function('measures.validity_end_date IS NOT NULL'.lit, 'measures.validity_end_date'.lit, 'modification_regulations.effective_end_date'.lit), :effective_end_date)).
      join_table(:right, :modification_regulations, modification_regulations__modification_regulation_id: :measures__measure_generating_regulation_id)
    end

    def with_measure_type(condition_measure_type)
      where(measures__measure_type: condition_measure_type.to_s)
    end

    def valid_since(first_effective_timestamp)
      where("measures.validity_start_date >= ?", first_effective_timestamp)
    end

    def valid_to(last_effective_timestamp)
      where("measures.validity_start_date <= ?", last_effective_timestamp)
    end

    def valid_before(last_effective_timestamp)
      where("measures.validity_start_date < ?", last_effective_timestamp)
    end

    def valid_from(timestamp)
      where("measures.validity_start_date >= ?", timestamp)
    end

    def not_terminated
      where("measures.validity_end_date IS NULL")
    end

    def terminated
      where("measures.validity_end_date IS NOT NULL")
    end

    def with_gono_id(goods_nomenclature_item_id)
      where(goods_nomenclature_item_id: goods_nomenclature_item_id)
    end

    def with_tariff_measure_number(tariff_measure_number)
      where(tariff_measure_number: tariff_measure_number)
    end

    def with_geographical_area(area)
      where(geographical_area: area)
    end

    def with_duty_amount(amount)
      join_table(:left, MeasureComponent, measures__measure_sid: :measure_components__measure_sid).
      where(measure_components__duty_amount: amount)
    end

    def for_candidate_measure(candidate_measure)
      where(measure_type: candidate_measure.measure_type,
            validity_start_date: candidate_measure.validity_start_date,
            additional_code_type: candidate_measure.additional_code_type,
            additional_code: candidate_measure.additional_code,
            goods_nomenclature_item_id: candidate_measure.goods_nomenclature_item_id,
            geographical_area: candidate_measure.geographical_area,
            national: true)
    end

    def expired_before(candidate_measure)
      where(measure_type: candidate_measure.measure_type,
            additional_code_type: candidate_measure.additional_code_type,
            additional_code: candidate_measure.additional_code,
            goods_nomenclature_item_id: candidate_measure.goods_nomenclature_item_id,
            geographical_area: candidate_measure.geographical_area,
            national: true).
      where("validity_start_date < ?", candidate_measure.validity_start_date).
      where(validity_end_date: nil)
    end
  end

  def_column_accessor :effective_end_date, :effective_start_date

  def generating_regulation_present?
    measure_generating_regulation_id.present? && measure_generating_regulation_role.present?
  end

  def measure_generating_regulation_id
    result = self[:measure_generating_regulation_id]

    # https://www.pivotaltracker.com/story/show/35164477
    case result
    when "D9500019"
      "D9601421"
    else
      result
    end
  end

  def generating_regulation_code(regulation_code = measure_generating_regulation_id)
    "#{regulation_code.first}#{regulation_code[3..6]}/#{regulation_code[1..2]}"
  end

  def generating_regulation_url(regulation_code = measure_generating_regulation_id)
    year = regulation_code[1..2]
    # When we get to 2071 assume that we don't care about the 1900's
    # or the EU has a better way to search
    if year.to_i > 70
      full_year = "19#{year}"
    else
      full_year = "20#{year}"
    end
    code = "3#{full_year}#{regulation_code.first}#{regulation_code[3..6]}"
    "http://eur-lex.europa.eu/Result.do?code=#{code}&RechType=RECH_celex"
  end

  def origin
    if measure_sid >= 0
      "eu"
    else
      "uk"
    end
  end

  def import
    measure_type.present? && measure_type.trade_movement_code.in?(MeasureType::IMPORT_MOVEMENT_CODES)
  end

  def export
    measure_type.present? && measure_type.trade_movement_code.in?(MeasureType::EXPORT_MOVEMENT_CODES)
  end

  def suspended?
    full_temporary_stop_regulation.present? || measure_partial_temporary_stop.present?
  end

  def suspending_regulation
    full_temporary_stop_regulation.presence || measure_partial_temporary_stop
  end
end


