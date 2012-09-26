class Measure < Sequel::Model
  set_primary_key :measure_sid
  plugin :time_machine, period_start_column: :effective_start_date,
                        period_end_column: :effective_end_date

  plugin :national

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

  def_column_alias :measure_type_id, :measure_type
  def_column_alias :additional_code_id, :additional_code
  def_column_alias :geographical_area_id, :geographical_area

  ######### Conformance validations 430
  def validate
    super
    # ME2 ME4 ME6 ME24
    # validates_presence([:measure_type, :geographical_area, :goods_nomenclature_sid, :measure_generating_regulation_id, :measure_generating_regulation_role])
    # ME1
    # validates_unique([:measure_type, :geographical_area, :goods_nomenclature_sid, :additional_code_type, :additional_code, :ordernumber, :reduction_indicator, :validity_start_date])
    # ME25
    validates_start_date
    # TODO:
    # ME3 ME7 ME8 ME88 ME16 ME115 ME25 ME32 ...
    # ME24 If no measure start date is specified it defaults to the regulation start date.
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

  def generating_regulation_present?
    measure_generating_regulation_id.present? && measure_generating_regulation_role.present?
  end

  def measure_generating_regulation_id
    result = self[:measure_generating_regulation_id]

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
    full_temporary_stop_regulation.present?
  end
end


