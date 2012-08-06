module Chief
  class Tamf < Sequel::Model(:chief_tamf)
    set_primary_key [:msrgp_code, :msr_type, :tty_code, :cngp_code, :cntry_orig, :fe_tsmp]
    
    set_dataset order(:msrgp_code.asc).
              order_more(:msr_type.asc).
              order_more(:tty_code.asc).
              order_more(:fe_tsmp.desc)
  end
end