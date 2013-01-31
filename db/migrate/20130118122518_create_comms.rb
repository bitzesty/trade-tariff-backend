Sequel.migration do
  change do
    create_table :chief_comm do
      DateTime :fe_tsmp
      String :amend_indicator, size: 1
      String :cmdty_code, size: 12
      DateTime :le_tsmp
      TrueClass :add_rlf_alwd_ind
      TrueClass :alcohol_cmdty
      DateTime :audit_tsmp
      TrueClass :chi_doti_rqd
      TrueClass :cmdty_bbeer
      TrueClass :cmdty_beer
      TrueClass :cmdty_euse_alwd
      TrueClass :cmdty_exp_rfnd
      TrueClass :cmdty_mdecln
      TrueClass :exp_lcnc_rqd
      TrueClass :ex_ec_scode_rqd
      BigDecimal :full_dty_adval1, size: [3,3]
      BigDecimal :full_dty_adval2, size: [3,3]
      String :full_dty_exch, size: 3
      BigDecimal :full_dty_spfc1, size: [7,4]
      BigDecimal :full_dty_spfc2, size: [7,4]
      String :full_dty_ttype, size: 3
      String :full_dty_uoq_c2, size: 3
      String :full_dty_uoq1, size: 3
      String :full_dty_uoq2, size: 3
      String :full_duty_type, size: 2
      TrueClass :im_ec_score_rqd
      TrueClass :imp_exp_use
      String :nba_id, size: 6
      TrueClass :perfume_cmdty
      String :rfa, size: 255
      Integer :season_end
      Integer :season_start
      String :spv_code, size: 7
      TrueClass :spv_xhdg
      String :uoq_code_cdu1, size: 3
      String :uoq_code_cdu2, size: 3
      String :uoq_code_cdu3, size: 3
      TrueClass :whse_cmdty
      TrueClass :wines_cmdty
    end
  end
end
