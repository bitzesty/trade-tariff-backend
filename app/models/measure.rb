class Measure < Sequel::Model
  plugin :time_machine, period_start_column: :measures__validity_start_date,
                        period_end_column: :effective_end_date

  set_primary_key :measure_sid

  # rename to Declarable
  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid,
                                   foreign_key: :goods_nomenclature_sid
  many_to_one :measure_type, key: {}, dataset: -> {
    actual(MeasureType).where(measure_type_id: self[:measure_type])
  }
  one_to_many :measure_conditions, key: :measure_sid
  one_to_one :geographical_area, dataset: -> {
    actual(GeographicalArea).where(geographical_area_sid: geographical_area_sid)
  }
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
  }
  one_to_many :measure_components, key: :measure_sid,
                                   primary_key: :measure_sid
  one_to_one :additional_code, key: :additional_code_sid

  one_to_one :quota_order_number, dataset: -> {
    actual(QuotaOrderNumber).where(quota_order_number_id: ordernumber)
  }

  delegate :measure_type_description, to: :measure_type

  def_column_alias :measure_type_id, :measure_type

  dataset_module do
    def with_base_regulations
      select(:measures.*).
      select_append(Sequel.as(:if.sql_function('measures.validity_end_date >= base_regulations.validity_end_date'.lit, 'base_regulations.validity_end_date'.lit, 'measures.validity_end_date'.lit), :effective_end_date)).
      join_table(:left, :base_regulations, base_regulations__base_regulation_id: :measures__measure_generating_regulation_id)
    end

    def with_modification_regulations
      select(:measures.*).
      select_append(Sequel.as(:if.sql_function('measures.validity_end_date >= modification_regulations.validity_end_date'.lit, 'modification_regulations.validity_end_date'.lit, 'measures.validity_end_date'.lit), :effective_end_date)).
      join_table(:left, :modification_regulations, modification_regulations__modification_regulation_id: :measures__measure_generating_regulation_id)
    end
  end

  def generating_regulation_present?
    measure_generating_regulation_id.present? && measure_generating_regulation_role.present?
  end

  def generating_regulation_code
    "#{measure_generating_regulation_id.first}#{measure_generating_regulation_id[3..6]}/#{measure_generating_regulation_id[1..2]}"
  end

  def generating_regulation_url
    year = measure_generating_regulation_id[1..2]
    # When we get to 2071 assume that we don't care about the 1900's
    # or the EU has a better way to search
    if year.to_i > 70
      full_year = "19#{year}"
    else
      full_year = "20#{year}"
    end
    code = "3#{full_year}#{measure_generating_regulation_id.first}#{measure_generating_regulation_id[3..6]}"
    "http://eur-lex.europa.eu/Result.do?code=#{code}&RechType=RECH_celex"
  end

  def origin
    "eu"
  end
end


