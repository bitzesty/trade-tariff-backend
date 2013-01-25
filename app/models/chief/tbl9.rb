module Chief
  class Tbl9 < Sequel::Model
    set_dataset db[:chief_tbl9].
                order(:fe_tsmp.asc)
  end
end
