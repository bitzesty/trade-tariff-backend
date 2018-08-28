Sequel.migration do
  up do

    run 'DROP VIEW public.full_temporary_stop_regulations;'

    alter_table :full_temporary_stop_regulations_oplog do
      add_column :complete_abrogation_regulation_role, Integer
      add_column :complete_abrogation_regulation_id, String
    end

    run %Q{
CREATE VIEW public.full_temporary_stop_regulations AS
 SELECT full_temporary_stop_regulations1.full_temporary_stop_regulation_role,
    full_temporary_stop_regulations1.full_temporary_stop_regulation_id,
    full_temporary_stop_regulations1.published_date,
    full_temporary_stop_regulations1.officialjournal_number,
    full_temporary_stop_regulations1.officialjournal_page,
    full_temporary_stop_regulations1.validity_start_date,
    full_temporary_stop_regulations1.validity_end_date,
    full_temporary_stop_regulations1.effective_enddate,
    full_temporary_stop_regulations1.explicit_abrogation_regulation_role,
    full_temporary_stop_regulations1.explicit_abrogation_regulation_id,
    full_temporary_stop_regulations1.replacement_indicator,
    full_temporary_stop_regulations1.information_text,
    full_temporary_stop_regulations1.approved_flag,
    full_temporary_stop_regulations1.complete_abrogation_regulation_id,
    full_temporary_stop_regulations1.complete_abrogation_regulation_role,
    full_temporary_stop_regulations1.oid,
    full_temporary_stop_regulations1.operation,
    full_temporary_stop_regulations1.operation_date
   FROM public.full_temporary_stop_regulations_oplog full_temporary_stop_regulations1
  WHERE ((full_temporary_stop_regulations1.oid IN ( SELECT max(full_temporary_stop_regulations2.oid) AS max
           FROM public.full_temporary_stop_regulations_oplog full_temporary_stop_regulations2
          WHERE (((full_temporary_stop_regulations1.full_temporary_stop_regulation_id)::text = (full_temporary_stop_regulations2.full_temporary_stop_regulation_id)::text) AND (full_temporary_stop_regulations1.full_temporary_stop_regulation_role = full_temporary_stop_regulations2.full_temporary_stop_regulation_role)))) AND ((full_temporary_stop_regulations1.operation)::text <> 'D'::text));
    }

  end

  down do

    run 'DROP VIEW public.full_temporary_stop_regulations;'

    alter_table :full_temporary_stop_regulations_oplog do
      drop_column :complete_abrogation_regulation_id
      drop_column :complete_abrogation_regulation_role
    end

    run %Q{
CREATE VIEW public.full_temporary_stop_regulations AS
 SELECT full_temporary_stop_regulations1.full_temporary_stop_regulation_role,
    full_temporary_stop_regulations1.full_temporary_stop_regulation_id,
    full_temporary_stop_regulations1.published_date,
    full_temporary_stop_regulations1.officialjournal_number,
    full_temporary_stop_regulations1.officialjournal_page,
    full_temporary_stop_regulations1.validity_start_date,
    full_temporary_stop_regulations1.validity_end_date,
    full_temporary_stop_regulations1.effective_enddate,
    full_temporary_stop_regulations1.explicit_abrogation_regulation_role,
    full_temporary_stop_regulations1.explicit_abrogation_regulation_id,
    full_temporary_stop_regulations1.replacement_indicator,
    full_temporary_stop_regulations1.information_text,
    full_temporary_stop_regulations1.approved_flag,
    full_temporary_stop_regulations1.oid,
    full_temporary_stop_regulations1.operation,
    full_temporary_stop_regulations1.operation_date
   FROM public.full_temporary_stop_regulations_oplog full_temporary_stop_regulations1
  WHERE ((full_temporary_stop_regulations1.oid IN ( SELECT max(full_temporary_stop_regulations2.oid) AS max
           FROM public.full_temporary_stop_regulations_oplog full_temporary_stop_regulations2
          WHERE (((full_temporary_stop_regulations1.full_temporary_stop_regulation_id)::text = (full_temporary_stop_regulations2.full_temporary_stop_regulation_id)::text) AND (full_temporary_stop_regulations1.full_temporary_stop_regulation_role = full_temporary_stop_regulations2.full_temporary_stop_regulation_role)))) AND ((full_temporary_stop_regulations1.operation)::text <> 'D'::text));
    }

  end
end
