class Measure < Sequel::Model
  VALID_ROLE_TYPE_IDS = [
    1, # Base regulation
    2, # Modification
    3, # Provisional anti-dumping/countervailing duty
    4  # Definitive anti-dumping/countervailing duty
  ]

  set_primary_key :measure_sid
  plugin :time_machine, period_start_column: :effective_start_date,
                        period_end_column: :effective_end_date

  plugin :national
  plugin :timestamps

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid,
                                   foreign_key: :goods_nomenclature_sid

  many_to_one :export_refund_nomenclature, key: :export_refund_nomenclature_sid,
                                   foreign_key: :export_refund_nomenclature_sid

  one_to_one :type, primary_key: :measure_type,
                    key: :measure_type_id,
                    class_name: MeasureType do |ds|
                      ds.with_actual(MeasureType)
                    end

  one_to_many :measure_conditions, key: :measure_sid

  one_to_one :geographical_area, key: :geographical_area_sid,
                                 primary_key: :geographical_area_sid do |ds|
    ds.with_actual(GeographicalArea)
  end

  many_to_many :excluded_geographical_areas, join_table: :measure_excluded_geographical_areas,
                                             left_key: :measure_sid,
                                             left_primary_key: :measure_sid,
                                             right_key: :excluded_geographical_area,
                                             right_primary_key: :geographical_area_id,
                                             class_name: 'GeographicalArea'

  many_to_many :footnotes, join_table: :footnote_association_measures,
                           left_key: :measure_sid,
                           right_key: [:footnote_id, :footnote_type_id] do |ds|
                             ds.with_actual(Footnote)
                           end

  one_to_many :footnote_association_measures, key: :measure_sid, primary_key: :measure_sid

  one_to_many :measure_components, key: :measure_sid

  one_to_one :additional_code, key: :additional_code_sid,
                               primary_key: :additional_code_sid do |ds|
    ds.with_actual(AdditionalCode)
  end

  many_to_one :adco_type, class_name: 'AdditionalCodeType',
                          key: :additional_code_type,
                          primary_key: :additional_code_type_id

  one_to_one :quota_order_number, key: :quota_order_number_id,
                                  primary_key: :ordernumber do |ds|
    ds.with_actual(QuotaOrderNumber)
  end

  many_to_many :full_temporary_stop_regulations, join_table: :fts_regulation_actions,
                                                 left_primary_key: :measure_generating_regulation_id,
                                                 left_key: :stopped_regulation_id,
                                                 right_key: :fts_regulation_id,
                                                 right_primary_key: :full_temporary_stop_regulation_id do |ds|
                                                   ds.with_actual(FullTemporaryStopRegulation)
                                                 end

  def full_temporary_stop_regulation
    full_temporary_stop_regulations.first
  end

  one_to_many :measure_partial_temporary_stops, primary_key: :measure_generating_regulation_id,
                                                key: :partial_temporary_stop_regulation_id

  def measure_partial_temporary_stop
    measure_partial_temporary_stops.first
  end

  one_to_one :modification_regulation, key: [:modification_regulation_id,
                                             :modification_regulation_role],
                                       primary_key: [:measure_generating_regulation_id,
                                                     :measure_generating_regulation_role]

  def_column_alias :measure_type_id, :measure_type
  def_column_alias :additional_code_id, :additional_code
  def_column_alias :geographical_area_id, :geographical_area

  validates do
    # ME2 ME4 ME6 ME24
    presence_of :measure_type, :geographical_area_sid, :goods_nomenclature_sid, :measure_generating_regulation_id, :measure_generating_regulation_role
    # ME1
    # TODO
    uniqueness_of [:measure_type, :geographical_area_sid, :goods_nomenclature_sid, :additional_code_type, :additional_code, :ordernumber, :reduction_indicator, :validity_start_date]
    # ME3 ME5 ME8 ME115 ME18 ME114 ME15
    # TODO
    validity_date_span_of :geographical_area, :type, :goods_nomenclature, :additional_code
    # ME25
    # TODO
    validity_dates
    # ME7 ME88
    associated :goods_nomenclature, ensure: :qualified_goods_nomenclature?
    # ME10
    associated :quota_order_number, ensure: :quota_order_number_present?,
                                    if: :type_order_number_capture_code_permitted?
    # ME12
    associated :additional_code_type, ensure: :adco_type_related_to_measure_type?,
                                      if: :additional_code_present?
    # ME86
    inclusion_of :measure_generating_regulation_role, in: VALID_ROLE_TYPE_IDS
    # ME26
    exclusion_of [:measure_generating_regulation_id, :measure_generating_regulation_role],
                  from: CompleteAbrogationRegulation.map([:complete_abrogation_regulation_id, :complete_abrogation_regulation_role])
    # ME27
    exclusion_of [:measure_generating_regulation_id, :measure_generating_regulation_role],
                  from: RegulationReplacement.map([:replaced_regulation_id, :replaced_regulation_role])
    # ME33
    # input_of :justification_regulation_id, :justification_regulation_role, requires: :is_ended?
    # ME34
    # presence_of :justification_regulation_id, :justification_regulation_role, if: :is_ended?
    # ME29
    associated :modification_regulation, ensure: :modification_regulation_base_regulation_not_completely_abrogated?
    # ME9
    presence_of :goods_nomenclature_item_id, if: :additional_code_blank?
    # ME13 ME14
    associated :additional_code, ensure: :additional_code_exists_as_meursing_code?,
                                 if: :adco_type_meursing?
    # ME17
    associated :additional_code, ensure: :additional_code_does_not_exist_as_meursing_code?,
                                 if: :adco_type_non_meursing?
    # ME116 ME118 ME119
    validity_date_span_of :quota_order_number, if: :should_validate_order_number_date_span?
    # ME117
    associated :quota_order_number, ensure: :quota_order_number_quota_order_number_origin_present?,
                                    if: :should_validate_order_number_date_span?
    # ME112 ME113
    associated :additional_code, ensure: :additional_code_exists_as_export_refund_code?,
                                 if: :adco_type_export_refund_agricultural?
    # ME19
    presence_of :goods_nomenclature_item_id, if: :adco_type_export_refund?
    associated :adco_type, ensure: :quota_order_number_blank?,
                           if: :adco_type_export_refund?
    # ME21
    associated :additional_code, ensure: :ern_adco_exists?,
                                 if: :adco_type_export_refund?
    validity_date_span_of :export_refund_nomenclature, if: :ern_adco_exists?
    # ME28
    input_of :measure_generating_regulation_id, requires: :regulation_is_not_replaced?
  end

  delegate :present?, :blank?, :exists_as_meursing_code?, :does_not_exist_as_meursing_code?, to: :additional_code, prefix: :additional_code, allow_nil: true
  delegate :present?, to: :quota_order_number, prefix: :quota_order_number, allow_nil: true
  delegate :order_number_capture_code_permitted?, to: :type, prefix: :type, allow_nil: true
  delegate :related_to_measure_type?, :meursing?, :non_meursing?, :export_refund?, :export_refund_agricultural?, to: :adco_type, prefix: :adco_type, allow_nil: true
  delegate :quota_order_number_origin_present?, :blank?, to: :quota_order_number, prefix: true, allow_nil: true
  delegate :base_regulation_not_completely_abrogated?, to: :modification_regulation, prefix: true, allow_nil: true
  delegate :validity_end_date, to: :goods_nomenclature, prefix: true, allow_nil: true

  def regulation_is_not_replaced?
    RegulationReplacement.where(replaced_regulation_id: measure_generating_regulation_id,
                                replaced_regulation_role: measure_generating_regulation_role,
                                geographical_area_id: geographical_area_id).none? &&
    RegulationReplacement.where(replaced_regulation_id: measure_generating_regulation_id,
                                replaced_regulation_role: measure_generating_regulation_role,
                                chapter_heading: goods_nomenclature_item_id.to_s.first(2)).none?
  end

  def should_validate_order_number_date_span?
    ordernumber.present? && validity_start_date > Date.new(2007,12,31) && ordernumber =~ /^09[^4]/
  end

  def ern_adco_exists?
    export_refund_nomenclature.present?
  end

  def qualified_goods_nomenclature?
    goods_nomenclature.producline_suffix == "80" &&
    goods_nomenclature.number_indents <= type.measure_explosion_level
  end

  def is_ended?
    validity_end_date.present?
  end

  # Soft-deleted
  def invalidated?
    invalidated_at.present?
  end

  def validate
    model.validate(self) unless self.invalidated?
  end

  ######### Conformance validations 430
  # def validate
    # super

    # TODO: ME16
    # Integrating a measure with an additional code when an equivalent or overlapping measures without additional code already exists and vice-versa, should be forbidden.
    # TODO: ME32
    # There may be no overlap in time with other measure occurrences with a goods code in the same nomenclature hierarchy which references the same measure type, geo area, order number, additional code and reduction indicator. This rule is not applicable for Meursing additional codes.
    # TODO: ME87
    # The VP of the measure (implicit or explicit) must reside within the effective VP of its supporting regulation. The effective VP is the VP of the regulation taking into account extensions and abrogation.


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
  # end

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

    def non_invalidated
      where(measures__invalidated_at: nil)
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
    measure_type.present? && type.trade_movement_code.in?(MeasureType::IMPORT_MOVEMENT_CODES)
  end

  def export
    measure_type.present? && type.trade_movement_code.in?(MeasureType::EXPORT_MOVEMENT_CODES)
  end

  def suspended?
    full_temporary_stop_regulation.present? || measure_partial_temporary_stop.present?
  end

  def suspending_regulation
    full_temporary_stop_regulation.presence || measure_partial_temporary_stop
  end

  def associated_to_non_open_ended_gono?
    goods_nomenclature.present? && goods_nomenclature.validity_end_date.present?
  end

  def order_number
    if quota_order_number.present?
      quota_order_number
    elsif ordernumber.present?
      # TODO refactor if possible
      qon = QuotaOrderNumber.new(quota_order_number_id: ordernumber)
      qon.associations[:quota_definition] = nil
      qon
    end
  end
end


