Sequel.migration do
  up do
    run %Q{
      DROP VIEW public.measures;
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measures AS
       SELECT measures1.measure_sid,
          measures1.measure_type_id,
          measures1.geographical_area_id,
          measures1.goods_nomenclature_item_id,
          measures1.validity_start_date,
          measures1.effective_start_date,
          measures1.validity_end_date,
          measures1.effective_end_date,
          measures1.measure_generating_regulation_role,
          measures1.measure_generating_regulation_id,
          measures1.justification_regulation_role,
          measures1.justification_regulation_id,
          measures1.stopped_flag,
          measures1.geographical_area_sid,
          measures1.goods_nomenclature_sid,
          measures1.ordernumber,
          measures1.additional_code_type_id,
          measures1.additional_code_id,
          measures1.additional_code_sid,
          measures1.reduction_indicator,
          measures1.export_refund_nomenclature_sid,
          measures1."national",
          measures1.tariff_measure_number,
          measures1.invalidated_by,
          measures1.invalidated_at,
          measures1.oid,
          measures1.operation,
          measures1.operation_date
         FROM public.measures_oplog measures1
        WHERE ((measures1.oid IN ( SELECT max(measures2.oid) AS max
                 FROM public.measures_oplog measures2
                WHERE (measures1.measure_sid = measures2.measure_sid))) AND ((measures1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      DROP VIEW public.measures;
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measures AS
       SELECT measures1.measure_sid,
          measures1.measure_type_id,
          measures1.geographical_area_id,
          measures1.goods_nomenclature_item_id,
          measures1.validity_start_date,
          COALESCE(measures1.effective_start_date, measures1.validity_start_date, b.validity_start_date, m.validity_start_date) effective_start_date,
          measures1.validity_end_date,
          COALESCE(measures1.effective_end_date, measures1.validity_end_date, b.effective_end_date, m.effective_end_date) effective_end_date,
          measures1.measure_generating_regulation_role,
          measures1.measure_generating_regulation_id,
          measures1.justification_regulation_role,
          measures1.justification_regulation_id,
          measures1.stopped_flag,
          measures1.geographical_area_sid,
          measures1.goods_nomenclature_sid,
          measures1.ordernumber,
          measures1.additional_code_type_id,
          measures1.additional_code_id,
          measures1.additional_code_sid,
          measures1.reduction_indicator,
          measures1.export_refund_nomenclature_sid,
          measures1."national",
          measures1.tariff_measure_number,
          measures1.invalidated_by,
          measures1.invalidated_at,
          measures1.oid,
          measures1.operation,
          measures1.operation_date
         FROM public.measures_oplog measures1
       LEFT JOIN base_regulations b ON (
               b.base_regulation_id = measures1.measure_generating_regulation_id
               AND b.base_regulation_role = measures1.measure_generating_regulation_role
             )
       LEFT JOIN modification_regulations m ON (
               m.modification_regulation_id = measures1.measure_generating_regulation_id
               AND m.modification_regulation_role = measures1.measure_generating_regulation_role
             )
        WHERE ((measures1.oid IN ( SELECT max(measures2.oid) AS max
                 FROM public.measures_oplog measures2
                WHERE (measures1.measure_sid = measures2.measure_sid))) AND ((measures1.operation)::text <> 'D'::text));
    }
  end
end
