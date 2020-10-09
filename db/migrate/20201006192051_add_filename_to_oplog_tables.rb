Sequel.migration do
  up do
    Sequel::Model.db.tables.select { |table_name| table_name.to_s.include?("_oplog") }.each do |table_name|
      alter_table table_name do
        add_column :filename, String
      end

      next if table_name == "quota_critical_events_oplog"

      # name of the view we are going to build
      view_name = table_name.to_s.split("_oplog").first
      # primary key of the view
      # from class that inherits from Sequel::Model
      pk = view_name.classify.constantize.primary_key
      # join conditions of primary_keys
      # necessary to build the view
      pk_assoc_hash = if pk.is_a?(Array)
                        pk.inject({}) { |memo, pk_part|
                          memo.merge!(:"#{view_name}1__#{pk_part}" => :"#{view_name}2__#{pk_part}")
                          memo
                        }
                      else
                        {:"#{view_name}1__#{pk}" => :"#{view_name}2__#{pk}"}
                      end

      # column names for the view
      # some columns from oplog are not necessary for the read view
      column_names = (Sequel::Model.db[table_name].columns - [:updated_at, :created_at])

      drop_view(view_name)

      create_view(view_name, Sequel::Model.db[:"#{table_name}___#{view_name}1"]
                                            .select(*column_names)
                                            .where(:"#{view_name}1__oid" => Sequel::Model.db[:"#{table_name}___#{view_name}2"]
                                                                                .select(Sequel.function(:max, :oid))
                                                                                .where(pk_assoc_hash))
                                            .where{ Sequel.~(:"#{view_name}1__operation" => "D") })
    end
    
    run QuotaCriticalEvents_20201006.up
  end

  down do
    Sequel::Model.db.tables.select { |table_name| table_name.to_s.include?("_oplog") }.each do |table_name|
      # name of the view we are going to build
      view_name = table_name.to_s.split("_oplog").first
      
      if table_name == "quota_critical_events_oplog"
        drop_view(view_name)

        alter_table table_name do
          drop_column :filename
        end

        run QuotaCriticalEvents_20201006.down
        next
      end
      
      # primary key of the view
      # from class that inherits from Sequel::Model
      pk = view_name.classify.constantize.primary_key
      # join conditions of primary_keys
      # necessary to build the view
      pk_assoc_hash = if pk.is_a?(Array)
                        pk.inject({}) { |memo, pk_part|
                          memo.merge!(:"#{view_name}1__#{pk_part}" => :"#{view_name}2__#{pk_part}")
                          memo
                        }
                      else
                        {:"#{view_name}1__#{pk}" => :"#{view_name}2__#{pk}"}
                      end

      # column names for the view
      # some columns from oplog are not necessary for the read view
      column_names = (Sequel::Model.db[table_name].columns - [:updated_at, :created_at, :filename])

      drop_view(view_name)

      alter_table table_name do
        drop_column :filename
      end

      create_view(view_name, Sequel::Model.db[:"#{table_name}___#{view_name}1"]
                                            .select(*column_names)
                                            .where(:"#{view_name}1__oid" => Sequel::Model.db[:"#{table_name}___#{view_name}2"]
                                                                                .select(Sequel.function(:max, :oid))
                                                                                .where(pk_assoc_hash))
                                            .where{ Sequel.~(:"#{view_name}1__operation" => "D") })
    end
  end
end

class QuotaCriticalEvents_20201006
  def self.up
    %Q{
      CREATE OR REPLACE VIEW quota_critical_events AS
        select quota_critical_events1.quota_definition_sid AS quota_definition_sid,
                quota_critical_events1.occurrence_timestamp AS occurrence_timestamp,
                quota_critical_events1.critical_state AS critical_state,
                quota_critical_events1.critical_state_change_date AS critical_state_change_date,
                quota_critical_events1.oid AS oid,
                quota_critical_events1.operation AS operation,
                quota_critical_events1.operation_date AS operation_date,
                quota_critical_events1.filename AS filename
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
              quota_critical_events1.operation <> "D"
            )
          )
    }
  end

  def self.down
    %Q{
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
              quota_critical_events1.operation <> "D"
            )
          )
    }
  end
end
