module Chief
  class Mfcm < Sequel::Model(:chief_mfcm)
    set_primary_key [:msrgp_code, :msr_type, :tty_code, :cmdty_code]
  end
end