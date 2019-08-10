namespace :tariff do
  namespace :measures do
    desc "Update measures#effective_start_date and measures#effective_end_date columns"
    task update_effective_dates: :environment do
      Sequel::Model.db.run(
"UPDATE measures_oplog
SET effective_start_date = COALESCE(
        validity_start_date,
        (SELECT b.validity_start_date
         FROM base_regulations b
         WHERE b.base_regulation_id = measure_generating_regulation_id
           AND b.base_regulation_role = measure_generating_regulation_role),
        (SELECT m.validity_start_date
         FROM modification_regulations m
         WHERE m.modification_regulation_id = measure_generating_regulation_id
           AND m.modification_regulation_role = measure_generating_regulation_role)
    ),
    effective_end_date   = COALESCE(
            validity_end_date,
            (SELECT b.effective_end_date
             FROM base_regulations b
             WHERE b.base_regulation_id = measure_generating_regulation_id
               AND b.base_regulation_role = measure_generating_regulation_role),
            (SELECT m.effective_end_date
             FROM modification_regulations m
             WHERE m.modification_regulation_id = measure_generating_regulation_id
               AND m.modification_regulation_role = measure_generating_regulation_role)
        )
WHERE oid IN (SELECT oid FROM measures);"
      )
    end
  end
end
