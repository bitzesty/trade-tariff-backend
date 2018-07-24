Sequel.migration do
  change do
    #
    # Footnote, FootnoteDescription, FootnoteDescriptionPeriod
    # in current db having:
    #
    #   footnote_id character varying(5)
    #
    # but in FootnoteAssociationMeasure
    #
    #   footnote_id character varying(3)
    #
    # This is wrong and break saving of FootnoteAssociationMeasure
    # if footnote_id is longer than 3 symbols
    #
    # This migration fixes this issue.

    tables_to_change = [
      :footnote_association_measures_oplog,
      :footnote_association_additional_codes_oplog,
      :footnote_association_erns_oplog,
      :footnote_association_goods_nomenclatures_oplog,
      :footnote_association_meursing_headings_oplog
    ]

    tables_to_change.map do |view_name|
      run "DROP VIEW public.#{view_name.to_s.gsub('_oplog', '')};"
    end

    tables_to_change.map do |table_name|
      alter_table table_name do
        set_column_type :footnote_id, String, size: 5
      end
    end

    run %Q{
      CREATE VIEW public.footnote_association_measures AS
       SELECT footnote_association_measures1.measure_sid,
          footnote_association_measures1.footnote_type_id,
          footnote_association_measures1.footnote_id,
          footnote_association_measures1."national",
          footnote_association_measures1.oid,
          footnote_association_measures1.operation,
          footnote_association_measures1.operation_date
         FROM public.footnote_association_measures_oplog footnote_association_measures1
        WHERE ((footnote_association_measures1.oid IN ( SELECT max(footnote_association_measures2.oid) AS max
                 FROM public.footnote_association_measures_oplog footnote_association_measures2
                WHERE ((footnote_association_measures1.measure_sid = footnote_association_measures2.measure_sid) AND ((footnote_association_measures1.footnote_id)::text = (footnote_association_measures2.footnote_id)::text) AND ((footnote_association_measures1.footnote_type_id)::text = (footnote_association_measures2.footnote_type_id)::text)))) AND ((footnote_association_measures1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnote_association_additional_codes AS
       SELECT footnote_association_additional_codes1.additional_code_sid,
          footnote_association_additional_codes1.footnote_type_id,
          footnote_association_additional_codes1.footnote_id,
          footnote_association_additional_codes1.validity_start_date,
          footnote_association_additional_codes1.validity_end_date,
          footnote_association_additional_codes1.additional_code_type_id,
          footnote_association_additional_codes1.additional_code,
          footnote_association_additional_codes1.oid,
          footnote_association_additional_codes1.operation,
          footnote_association_additional_codes1.operation_date
         FROM public.footnote_association_additional_codes_oplog footnote_association_additional_codes1
        WHERE ((footnote_association_additional_codes1.oid IN ( SELECT max(footnote_association_additional_codes2.oid) AS max
                 FROM public.footnote_association_additional_codes_oplog footnote_association_additional_codes2
                WHERE (((footnote_association_additional_codes1.footnote_id)::text = (footnote_association_additional_codes2.footnote_id)::text) AND ((footnote_association_additional_codes1.footnote_type_id)::text = (footnote_association_additional_codes2.footnote_type_id)::text) AND (footnote_association_additional_codes1.additional_code_sid = footnote_association_additional_codes2.additional_code_sid)))) AND ((footnote_association_additional_codes1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnote_association_erns AS
       SELECT footnote_association_erns1.export_refund_nomenclature_sid,
          footnote_association_erns1.footnote_type,
          footnote_association_erns1.footnote_id,
          footnote_association_erns1.validity_start_date,
          footnote_association_erns1.validity_end_date,
          footnote_association_erns1.goods_nomenclature_item_id,
          footnote_association_erns1.additional_code_type,
          footnote_association_erns1.export_refund_code,
          footnote_association_erns1.productline_suffix,
          footnote_association_erns1.oid,
          footnote_association_erns1.operation,
          footnote_association_erns1.operation_date
         FROM public.footnote_association_erns_oplog footnote_association_erns1
        WHERE ((footnote_association_erns1.oid IN ( SELECT max(footnote_association_erns2.oid) AS max
                 FROM public.footnote_association_erns_oplog footnote_association_erns2
                WHERE ((footnote_association_erns1.export_refund_nomenclature_sid = footnote_association_erns2.export_refund_nomenclature_sid) AND ((footnote_association_erns1.footnote_id)::text = (footnote_association_erns2.footnote_id)::text) AND ((footnote_association_erns1.footnote_type)::text = (footnote_association_erns2.footnote_type)::text) AND (footnote_association_erns1.validity_start_date = footnote_association_erns2.validity_start_date)))) AND ((footnote_association_erns1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnote_association_goods_nomenclatures AS
       SELECT footnote_association_goods_nomenclatures1.goods_nomenclature_sid,
          footnote_association_goods_nomenclatures1.footnote_type,
          footnote_association_goods_nomenclatures1.footnote_id,
          footnote_association_goods_nomenclatures1.validity_start_date,
          footnote_association_goods_nomenclatures1.validity_end_date,
          footnote_association_goods_nomenclatures1.goods_nomenclature_item_id,
          footnote_association_goods_nomenclatures1.productline_suffix,
          footnote_association_goods_nomenclatures1."national",
          footnote_association_goods_nomenclatures1.oid,
          footnote_association_goods_nomenclatures1.operation,
          footnote_association_goods_nomenclatures1.operation_date
         FROM public.footnote_association_goods_nomenclatures_oplog footnote_association_goods_nomenclatures1
        WHERE ((footnote_association_goods_nomenclatures1.oid IN ( SELECT max(footnote_association_goods_nomenclatures2.oid) AS max
                 FROM public.footnote_association_goods_nomenclatures_oplog footnote_association_goods_nomenclatures2
                WHERE (((footnote_association_goods_nomenclatures1.footnote_id)::text = (footnote_association_goods_nomenclatures2.footnote_id)::text) AND ((footnote_association_goods_nomenclatures1.footnote_type)::text = (footnote_association_goods_nomenclatures2.footnote_type)::text) AND (footnote_association_goods_nomenclatures1.goods_nomenclature_sid = footnote_association_goods_nomenclatures2.goods_nomenclature_sid)))) AND ((footnote_association_goods_nomenclatures1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE VIEW public.footnote_association_meursing_headings AS
       SELECT footnote_association_meursing_headings1.meursing_table_plan_id,
          footnote_association_meursing_headings1.meursing_heading_number,
          footnote_association_meursing_headings1.row_column_code,
          footnote_association_meursing_headings1.footnote_type,
          footnote_association_meursing_headings1.footnote_id,
          footnote_association_meursing_headings1.validity_start_date,
          footnote_association_meursing_headings1.validity_end_date,
          footnote_association_meursing_headings1.oid,
          footnote_association_meursing_headings1.operation,
          footnote_association_meursing_headings1.operation_date
         FROM public.footnote_association_meursing_headings_oplog footnote_association_meursing_headings1
        WHERE ((footnote_association_meursing_headings1.oid IN ( SELECT max(footnote_association_meursing_headings2.oid) AS max
                 FROM public.footnote_association_meursing_headings_oplog footnote_association_meursing_headings2
                WHERE (((footnote_association_meursing_headings1.footnote_id)::text = (footnote_association_meursing_headings2.footnote_id)::text) AND ((footnote_association_meursing_headings1.meursing_table_plan_id)::text = (footnote_association_meursing_headings2.meursing_table_plan_id)::text)))) AND ((footnote_association_meursing_headings1.operation)::text <> 'D'::text));
    }
  end
end
