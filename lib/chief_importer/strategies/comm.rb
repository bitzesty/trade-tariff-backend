class ChiefImporter
  module Strategies
    class COMM < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          amend_indicator: 1,
          cmdty_code: [2, :chief_code],
          le_tsmp: [3, :chief_date],
          add_rlf_alwd_ind: [5, :chief_boolean],
          alcohol_cmdty: [6, :chief_boolean],
          audit_tsmp: [7, :chief_date],
          chi_doti_rqd: [8, :chief_boolean],
          cmdty_bbeer: [9, :chief_boolean],
          cmdty_beer: [10, :chief_boolean],
          cmdty_euse_alwd: [11, :chief_boolean],
          cmdty_exp_rfnd: [12, :chief_boolean],
          cmdty_mdecln: [13, :chief_boolean],
          exp_lcnc_rqd: [14, :chief_boolean],
          ex_ec_scode_rqd: [15, :chief_boolean],
          full_dty_adval1: [16, :chief_decimal],
          full_dty_adval2: [17, :chief_decimal],
          full_dty_exch: [18, :chief_string],
          full_dty_spfc1: [19, :chief_decimal],
          full_dty_spfc2: [20, :chief_decimal],
          full_dty_ttype: [21, :chief_string],
          full_dty_uoq_c2: [22, :chief_string],
          full_dty_uoq1: [23, :chief_string],
          full_dty_uoq2: [24, :chief_string],
          full_duty_type: [25, :chief_string],
          im_ec_score_rqd: [26, :chief_boolean],
          imp_exp_use: [27, :chief_boolean],
          nba_id: [28, :chief_string],
          perfume_cmdty: [29, :chief_boolean],
          rfa: [30, :chief_string],
          season_end: [31, :chief_decimal],
          season_start: [32, :chief_decimal],
          spv_code: [33, :chief_string],
          spv_xhdg: [34, :chief_boolean],
          uoq_code_cdu1: [35, :chief_string],
          uoq_code_cdu2: [36, :chief_string],
          uoq_code_cdu3: [37, :chief_string],
          whse_cmdty: [38, :chief_boolean],
          wines_cmdty: [39, :chief_boolean]

      process(:update) {
        Chief::Comm.insert(map)
      }

      process(:insert) {
        Chief::Comm.insert(map)
      }

      process(:delete) {
        Chief::Comm.insert(map)
      }
    end
  end
end
