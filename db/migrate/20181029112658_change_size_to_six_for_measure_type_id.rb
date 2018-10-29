Sequel.migration do
  up do
    run %Q{
      DROP VIEW public.additional_code_type_measure_types;
      DROP VIEW public.measure_type_descriptions;
      DROP VIEW public.measure_types;
      DROP VIEW public.measures;
      DROP VIEW public.regulation_replacements;
    }

    alter_table :additional_code_type_measure_types_oplog do
      set_column_type :measure_type_id, String, size: 6
    end

    alter_table :chief_measure_type_adco do
      set_column_type :measure_type_id, String, size: 6
    end

    alter_table :chief_measure_type_footnote do
      set_column_type :measure_type_id, String, size: 6
    end

    alter_table :measure_type_descriptions_oplog do
      set_column_type :measure_type_id, String, size: 6
    end

    alter_table :measure_types_oplog do
      set_column_type :measure_type_id, String, size: 6
    end

    alter_table :measures_oplog do
      set_column_type :measure_type_id, String, size: 6
    end

    alter_table :regulation_replacements_oplog do
      set_column_type :measure_type_id, String, size: 6
    end

    run %Q{
      CREATE OR REPLACE VIEW public.additional_code_type_measure_types AS
       SELECT additional_code_type_measure_types1.measure_type_id,
          additional_code_type_measure_types1.additional_code_type_id,
          additional_code_type_measure_types1.validity_start_date,
          additional_code_type_measure_types1.validity_end_date,
          additional_code_type_measure_types1."national",
          additional_code_type_measure_types1.oid,
          additional_code_type_measure_types1.operation,
          additional_code_type_measure_types1.operation_date
         FROM public.additional_code_type_measure_types_oplog additional_code_type_measure_types1
        WHERE ((additional_code_type_measure_types1.oid IN ( SELECT max(additional_code_type_measure_types2.oid) AS max
                 FROM public.additional_code_type_measure_types_oplog additional_code_type_measure_types2
                WHERE (((additional_code_type_measure_types1.measure_type_id)::text = (additional_code_type_measure_types2.measure_type_id)::text) AND ((additional_code_type_measure_types1.additional_code_type_id)::text = (additional_code_type_measure_types2.additional_code_type_id)::text)))) AND ((additional_code_type_measure_types1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measure_type_descriptions AS
       SELECT measure_type_descriptions1.measure_type_id,
          measure_type_descriptions1.language_id,
          measure_type_descriptions1.description,
          measure_type_descriptions1."national",
          measure_type_descriptions1.oid,
          measure_type_descriptions1.operation,
          measure_type_descriptions1.operation_date
         FROM public.measure_type_descriptions_oplog measure_type_descriptions1
        WHERE ((measure_type_descriptions1.oid IN ( SELECT max(measure_type_descriptions2.oid) AS max
                 FROM public.measure_type_descriptions_oplog measure_type_descriptions2
                WHERE ((measure_type_descriptions1.measure_type_id)::text = (measure_type_descriptions2.measure_type_id)::text))) AND ((measure_type_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measure_types AS
       SELECT measure_types1.measure_type_id,
          measure_types1.validity_start_date,
          measure_types1.validity_end_date,
          measure_types1.trade_movement_code,
          measure_types1.priority_code,
          measure_types1.measure_component_applicable_code,
          measure_types1.origin_dest_code,
          measure_types1.order_number_capture_code,
          measure_types1.measure_explosion_level,
          measure_types1.measure_type_series_id,
          measure_types1."national",
          measure_types1.measure_type_acronym,
          measure_types1.oid,
          measure_types1.operation,
          measure_types1.operation_date
         FROM public.measure_types_oplog measure_types1
        WHERE ((measure_types1.oid IN ( SELECT max(measure_types2.oid) AS max
                 FROM public.measure_types_oplog measure_types2
                WHERE ((measure_types1.measure_type_id)::text = (measure_types2.measure_type_id)::text))) AND ((measure_types1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measures AS
       SELECT measures1.measure_sid,
          measures1.measure_type_id,
          measures1.geographical_area_id,
          measures1.goods_nomenclature_item_id,
          measures1.validity_start_date,
          measures1.validity_end_date,
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

    run %Q{
      CREATE OR REPLACE VIEW public.regulation_replacements AS
       SELECT regulation_replacements1.geographical_area_id,
          regulation_replacements1.chapter_heading,
          regulation_replacements1.replacing_regulation_role,
          regulation_replacements1.replacing_regulation_id,
          regulation_replacements1.replaced_regulation_role,
          regulation_replacements1.replaced_regulation_id,
          regulation_replacements1.measure_type_id,
          regulation_replacements1.oid,
          regulation_replacements1.operation,
          regulation_replacements1.operation_date
         FROM public.regulation_replacements_oplog regulation_replacements1
        WHERE ((regulation_replacements1.oid IN ( SELECT max(regulation_replacements2.oid) AS max
                 FROM public.regulation_replacements_oplog regulation_replacements2
                WHERE (((regulation_replacements1.replacing_regulation_id)::text = (regulation_replacements2.replacing_regulation_id)::text) AND (regulation_replacements1.replacing_regulation_role = regulation_replacements2.replacing_regulation_role) AND ((regulation_replacements1.replaced_regulation_id)::text = (regulation_replacements2.replaced_regulation_id)::text) AND (regulation_replacements1.replaced_regulation_role = regulation_replacements2.replaced_regulation_role)))) AND ((regulation_replacements1.operation)::text <> 'D'::text));
    }
  end

  down do
    run %Q{
      DROP VIEW public.additional_code_type_measure_types;
      DROP VIEW public.measure_type_descriptions;
      DROP VIEW public.measure_types;
      DROP VIEW public.measures;
      DROP VIEW public.regulation_replacements;
    }

    alter_table :additional_code_type_measure_types_oplog do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :chief_measure_type_adco do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :chief_measure_type_footnote do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :measure_type_descriptions_oplog do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :measure_types_oplog do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :measures_oplog do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :regulation_replacements_oplog do
      set_column_type :measure_type_id, String, size: 3
    end

    run %Q{
      CREATE OR REPLACE VIEW public.additional_code_type_measure_types AS
       SELECT additional_code_type_measure_types1.measure_type_id,
          additional_code_type_measure_types1.additional_code_type_id,
          additional_code_type_measure_types1.validity_start_date,
          additional_code_type_measure_types1.validity_end_date,
          additional_code_type_measure_types1."national",
          additional_code_type_measure_types1.oid,
          additional_code_type_measure_types1.operation,
          additional_code_type_measure_types1.operation_date
         FROM public.additional_code_type_measure_types_oplog additional_code_type_measure_types1
        WHERE ((additional_code_type_measure_types1.oid IN ( SELECT max(additional_code_type_measure_types2.oid) AS max
                 FROM public.additional_code_type_measure_types_oplog additional_code_type_measure_types2
                WHERE (((additional_code_type_measure_types1.measure_type_id)::text = (additional_code_type_measure_types2.measure_type_id)::text) AND ((additional_code_type_measure_types1.additional_code_type_id)::text = (additional_code_type_measure_types2.additional_code_type_id)::text)))) AND ((additional_code_type_measure_types1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measure_type_descriptions AS
       SELECT measure_type_descriptions1.measure_type_id,
          measure_type_descriptions1.language_id,
          measure_type_descriptions1.description,
          measure_type_descriptions1."national",
          measure_type_descriptions1.oid,
          measure_type_descriptions1.operation,
          measure_type_descriptions1.operation_date
         FROM public.measure_type_descriptions_oplog measure_type_descriptions1
        WHERE ((measure_type_descriptions1.oid IN ( SELECT max(measure_type_descriptions2.oid) AS max
                 FROM public.measure_type_descriptions_oplog measure_type_descriptions2
                WHERE ((measure_type_descriptions1.measure_type_id)::text = (measure_type_descriptions2.measure_type_id)::text))) AND ((measure_type_descriptions1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measure_types AS
       SELECT measure_types1.measure_type_id,
          measure_types1.validity_start_date,
          measure_types1.validity_end_date,
          measure_types1.trade_movement_code,
          measure_types1.priority_code,
          measure_types1.measure_component_applicable_code,
          measure_types1.origin_dest_code,
          measure_types1.order_number_capture_code,
          measure_types1.measure_explosion_level,
          measure_types1.measure_type_series_id,
          measure_types1."national",
          measure_types1.measure_type_acronym,
          measure_types1.oid,
          measure_types1.operation,
          measure_types1.operation_date
         FROM public.measure_types_oplog measure_types1
        WHERE ((measure_types1.oid IN ( SELECT max(measure_types2.oid) AS max
                 FROM public.measure_types_oplog measure_types2
                WHERE ((measure_types1.measure_type_id)::text = (measure_types2.measure_type_id)::text))) AND ((measure_types1.operation)::text <> 'D'::text));
    }

    run %Q{
      CREATE OR REPLACE VIEW public.measures AS
       SELECT measures1.measure_sid,
          measures1.measure_type_id,
          measures1.geographical_area_id,
          measures1.goods_nomenclature_item_id,
          measures1.validity_start_date,
          measures1.validity_end_date,
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

    run %Q{
      CREATE OR REPLACE VIEW public.regulation_replacements AS
       SELECT regulation_replacements1.geographical_area_id,
          regulation_replacements1.chapter_heading,
          regulation_replacements1.replacing_regulation_role,
          regulation_replacements1.replacing_regulation_id,
          regulation_replacements1.replaced_regulation_role,
          regulation_replacements1.replaced_regulation_id,
          regulation_replacements1.measure_type_id,
          regulation_replacements1.oid,
          regulation_replacements1.operation,
          regulation_replacements1.operation_date
         FROM public.regulation_replacements_oplog regulation_replacements1
        WHERE ((regulation_replacements1.oid IN ( SELECT max(regulation_replacements2.oid) AS max
                 FROM public.regulation_replacements_oplog regulation_replacements2
                WHERE (((regulation_replacements1.replacing_regulation_id)::text = (regulation_replacements2.replacing_regulation_id)::text) AND (regulation_replacements1.replacing_regulation_role = regulation_replacements2.replacing_regulation_role) AND ((regulation_replacements1.replaced_regulation_id)::text = (regulation_replacements2.replaced_regulation_id)::text) AND (regulation_replacements1.replaced_regulation_role = regulation_replacements2.replaced_regulation_role)))) AND ((regulation_replacements1.operation)::text <> 'D'::text));
    }
  end
end
