module Chief
  class Tbl9 < Sequel::Model
    set_dataset db[:chief_tbl9].
                order(Sequel.asc(:fe_tsmp))
  end
end
