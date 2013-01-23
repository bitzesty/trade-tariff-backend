module Chief
  class Comm < Sequel::Model
    set_dataset db[:chief_comm].
                order(:fe_tsmp.asc)

    set_primary_key [:fe_tsmp, :cmdty_code, :audit_tsmp]
  end
end
