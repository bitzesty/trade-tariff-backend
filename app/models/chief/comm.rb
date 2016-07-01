module Chief
  class Comm < Sequel::Model(Sequel::Model.db[:chief_comm].order(Sequel.asc(:fe_tsmp)))
    plugin :time_machine, period_start_column: Sequel.qualify(:chief_comm, :fe_tsmp),
                          period_end_column: Sequel.qualify(:chief_comm, :le_tsmp)

    set_primary_key [:fe_tsmp, :cmdty_code, :audit_tsmp]
  end
end
