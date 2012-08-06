module Chief
  class Mfcm < Sequel::Model(:chief_mfcm)
    set_primary_key [:msrgp_code, :msr_type, :tty_code, :cmdty_code, :fe_tsmp]
     
    set_dataset order(:msrgp_code.asc).
                order_more(:msr_type.asc).
                order_more(:tty_code.asc).
                order_more(:fe_tsmp.desc)
  end
end
