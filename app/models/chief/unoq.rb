module Chief
  class Unoq < Sequel::Model
    set_dataset db[:chief_tbl9].
                filter(tbl_type: 'UNOQ').
                order(Sequel.asc(:fe_tsmp))

    set_primary_key [:tbl_type, :tbl_code]
  end
end
