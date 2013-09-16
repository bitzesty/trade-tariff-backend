class Footnote < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_id, :footnote_type_id]
  plugin :conformance_validator

  set_primary_key [:footnote_id, :footnote_type_id]


  many_to_many :footnote_descriptions, join_table: :footnote_description_periods,
                                       left_primary_key: [:footnote_id, :footnote_type_id],
                                       left_key: [:footnote_id, :footnote_type_id],
                                       right_key: [:footnote_description_period_sid,
                                                   :footnote_type_id,
                                                   :footnote_id],
                                       right_primary_key: [:footnote_description_period_sid,
                                                           :footnote_type_id,
                                                           :footnote_id] do |ds|
    ds.with_actual(FootnoteDescriptionPeriod)
      .order(Sequel.desc(:footnote_description_periods__validity_start_date))
  end

  def footnote_description
    footnote_descriptions.first
  end

  one_to_one :footnote_type, primary_key: :footnote_type_id,
                             key: :footnote_type_id

  one_to_many :footnote_description_periods, primary_key: [:footnote_id,
                                                           :footnote_type_id],
                                             key: [:footnote_id,
                                                   :footnote_type_id]
  many_to_many :measures, join_table: :footnote_association_measures,
                          left_key: [:footnote_id, :footnote_type_id],
                          right_key: [:measure_sid]
  one_to_many :footnote_association_goods_nomenclatures, key: [:footnote_id, :footnote_type],
                                                         primary_key: [:footnote_id, :footnote_type_id]
  many_to_many :goods_nomenclatures, join_table: :footnote_association_goods_nomenclatures,
                                     left_key: [:footnote_id, :footnote_type],
                                     right_key: [:goods_nomenclature_sid]
  one_to_many :footnote_association_erns, key: [:footnote_id, :footnote_type],
                                          primary_key: [:footnote_id, :footnote_type_id]
  many_to_many :export_refund_nomenclatures, join_table: :footnote_association_erns,
                                     left_key: [:footnote_id, :footnote_type],
                                     right_key: [:export_refund_nomenclature_sid]
  one_to_many :footnote_association_additional_codes, key: [:footnote_id, :footnote_type_id],
                                                      primary_key: [:footnote_id, :footnote_type_id]
  many_to_many :additional_codes, join_table: :footnote_association_additional_codes,
                                  left_key: [:footnote_id, :footnote_type_id],
                                  right_key: [:additional_code_sid]
  many_to_many :meursing_headings, join_table: :footnote_association_meursing_headings,
                                  left_key: [:footnote_id, :footnote_type],
                                  right_key: [:meursing_table_plan_id, :meursing_heading_number]


  delegate :description, to: :footnote_description

    # FO4
    # length_of :footnote_description_periods, minimum: 1
    # # FO4
    # associated :footnote_description_periods, ensure: :first_footnote_description_period_is_valid
    # # FO5, FO6, FO7, FO9, FO10
    # associated [:measures,
    #             :goods_nomenclatures,
    #             :export_refund_nomenclatures,
    #             :additional_codes,
    #             :meursing_headings], ensure: :spans_validity_period_of_associations
    # # FO17
    # associated :footnote_type, ensure: :footnote_type_validity_period_spans_validity_periods

  def first_footnote_description_period_is_valid
    period = footnote_description_periods.first

    period.validity_start_date == validity_start_date &&
    footnote_description_periods_dataset.where(validity_start_date: period.validity_start_date).count == 1 &&
    ((validity_end_date.present?) ? period.validity_start_date <= validity_end_date : true)
  end

  def spans_validity_period_of_associations
    # No need to repeat this check when validating, so cache in variable
    @spans_validity_periods ||= [:measures, :goods_nomenclatures,
                                 :export_refund_nomenclatures,
                                 :additional_codes,
                                 :meursing_headings].all? { |association|
      send(association).all? { |associated_record|
        validity_start_date <= associated_record.validity_start_date &&
        ((validity_end_date.present?) ? validity_end_date >= associated_record.validity_end_date : true)
      }
    }
  end

  def footnote_type_validity_period_spans_validity_periods
    validity_start_date >= footnote_type.validity_start_date &&
    ((validity_end_date.present?) ? validity_end_date <= footnote_type.validity_end_date : true)
  end

  def code
    "#{footnote_type_id}#{footnote_id}"
  end
end
