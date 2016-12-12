Sequel.migration do
  up do
    run %Q{
      -- UPDATE footnotes_oplog

      DROP VIEW footnotes;

      ALTER TABLE footnotes_oplog
        ALTER COLUMN footnote_id TYPE varchar(5);

      CREATE VIEW footnotes AS
       SELECT footnotes1.footnote_id,
          footnotes1.footnote_type_id,
          footnotes1.validity_start_date,
          footnotes1.validity_end_date,
          footnotes1."national",
          footnotes1.oid,
          footnotes1.operation,
          footnotes1.operation_date
         FROM footnotes_oplog footnotes1
        WHERE ((footnotes1.oid IN ( SELECT max(footnotes2.oid) AS MAX
                 FROM footnotes_oplog footnotes2
                WHERE (((footnotes1.footnote_type_id)::text = (footnotes2.footnote_type_id)::text) AND ((footnotes1.footnote_id)::text = (footnotes2.footnote_id)::text)))) AND ((footnotes1.operation)::text <> 'D'::text));


      -- UPDATE footnote_description_periods_oplog

      DROP VIEW footnote_description_periods;

      ALTER TABLE footnote_description_periods_oplog
        ALTER COLUMN footnote_id TYPE varchar(5);

      CREATE VIEW footnote_description_periods AS
       SELECT footnote_description_periods1.footnote_description_period_sid,
          footnote_description_periods1.footnote_type_id,
          footnote_description_periods1.footnote_id,
          footnote_description_periods1.validity_start_date,
          footnote_description_periods1.validity_end_date,
          footnote_description_periods1."national",
          footnote_description_periods1.oid,
          footnote_description_periods1.operation,
          footnote_description_periods1.operation_date
         FROM footnote_description_periods_oplog footnote_description_periods1
        WHERE ((footnote_description_periods1.oid IN ( SELECT max(footnote_description_periods2.oid) AS max
                 FROM footnote_description_periods_oplog footnote_description_periods2
                WHERE (((footnote_description_periods1.footnote_id)::text = (footnote_description_periods2.footnote_id)::text) AND ((footnote_description_periods1.footnote_type_id)::text = (footnote_description_periods2.footnote_type_id)::text) AND (footnote_description_periods1.footnote_description_period_sid = footnote_description_periods2.footnote_description_period_sid)))) AND ((footnote_description_periods1.operation)::text <> 'D'::text));


      -- UPDATE footnote_descriptions_oplog

      DROP VIEW footnote_descriptions;

      ALTER TABLE footnote_descriptions_oplog
        ALTER COLUMN footnote_id TYPE varchar(5);


      CREATE VIEW footnote_descriptions AS
      SELECT footnote_descriptions1.footnote_description_period_sid,
        footnote_descriptions1.footnote_type_id,
        footnote_descriptions1.footnote_id,
        footnote_descriptions1.language_id,
        footnote_descriptions1.description,
        footnote_descriptions1."national",
        footnote_descriptions1.oid,
        footnote_descriptions1.operation,
        footnote_descriptions1.operation_date
       FROM footnote_descriptions_oplog footnote_descriptions1
      WHERE ((footnote_descriptions1.oid IN ( SELECT max(footnote_descriptions2.oid) AS max
               FROM footnote_descriptions_oplog footnote_descriptions2
              WHERE ((footnote_descriptions1.footnote_description_period_sid = footnote_descriptions2.footnote_description_period_sid) AND ((footnote_descriptions1.footnote_id)::text = (footnote_descriptions2.footnote_id)::text) AND ((footnote_descriptions1.footnote_type_id)::text = (footnote_descriptions2.footnote_type_id)::text)))) AND ((footnote_descriptions1.operation)::text <> 'D'::text));


    }
  end
end
