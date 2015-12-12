Sequel.migration do
  up do
    run %Q{
      CREATE OR REPLACE VIEW quota_critical_events AS
        select quota_critical_events1.quota_definition_sid AS quota_definition_sid,
                quota_critical_events1.occurrence_timestamp AS occurrence_timestamp,
                quota_critical_events1.critical_state AS critical_state,
                quota_critical_events1.critical_state_change_date AS critical_state_change_date,
                quota_critical_events1.oid AS oid,
                quota_critical_events1.operation AS operation,
                quota_critical_events1.operation_date AS operation_date
        from
          quota_critical_events_oplog quota_critical_events1
        where
          (
            quota_critical_events1.oid in (
              select max(quota_critical_events2.oid)
              from quota_critical_events_oplog quota_critical_events2
              where
                (
                  quota_critical_events1.quota_definition_sid = quota_critical_events2.quota_definition_sid
                  and quota_critical_events1.occurrence_timestamp = quota_critical_events2.occurrence_timestamp
                )
              group by quota_critical_events2.oid
              order by quota_critical_events2.oid desc
            ) and (
              quota_critical_events1.operation <> 'D'
            )
          )
    }
  end

  down do
    run %Q{
      CREATE OR REPLACE VIEW quota_critical_events AS
        select quota_critical_events1.quota_definition_sid AS quota_definition_sid,
                quota_critical_events1.occurrence_timestamp AS occurrence_timestamp,
                quota_critical_events1.critical_state AS critical_state,
                quota_critical_events1.critical_state_change_date AS critical_state_change_date,
                quota_critical_events1.oid AS oid,
                quota_critical_events1.operation AS operation,
                quota_critical_events1.operation_date AS operation_date
        from
          quota_critical_events_oplog quota_critical_events1
        where
          (
            quota_critical_events1.oid in (
              select max(quota_critical_events2.oid)
              from quota_critical_events_oplog quota_critical_events2
              where
                (quota_critical_events1.quota_definition_sid = quota_critical_events2.quota_definition_sid)
              group by quota_critical_events2.oid
              order by quota_critical_events2.oid desc
            ) and (
              quota_critical_events1.operation <> 'D'
            )
          )
    }
  end
end
