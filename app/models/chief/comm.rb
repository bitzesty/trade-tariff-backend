module Chief
  class Comm < Sequel::Model
    set_dataset db[:chief_comm].
                order(:audit_tsmp.asc)
  end
end
