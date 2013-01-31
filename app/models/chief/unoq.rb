module Chief
  class Unoq < Sequel::Model
    set_dataset db[:chief_tbl9].
                filter(tbl_type: 'UNOQ').
                order(:fe_tsmp.asc)

    set_primary_key [:tbl_type, :tbl_code]
  end
end
