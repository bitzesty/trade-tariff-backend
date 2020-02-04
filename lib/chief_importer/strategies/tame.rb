class ChiefImporter
  module Strategies
    class Tame < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: 2,
          msr_type: 3,
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          le_tsmp: [6, :chief_date],
          adval_rate: [8, :chief_decimal],
          alch_sgth: [9, :chief_decimal],
          audit_tsmp: [10, :chief_date],
          cap_ai_stmt: 11,
          cap_max_pct: [12, :chief_decimal],
          cmdty_msr_xhdg: 13,
          comp_mthd: 14,
          cpc_wvr_phb: 15,
          ec_msr_set: 16,
          ec_sctr: 17,
          mip_band_exch: 18,
          mip_rate_exch: 19,
          mip_uoq_code: 20,
          nba_id: 21,
          null_tri_rqd: 22,
          qta_code_uk: 23,
          qta_elig_use: 24,
          qta_exch_rate: 25,
          qta_no: 26,
          qta_uoq_code: 27,
          rfa: 28,
          rfs_code_1: 29,
          rfs_code_2: 30,
          rfs_code_3: 31,
          rfs_code_4: 32,
          rfs_code_5: 33,
          tdr_spr_sur: 34,
          exports_use_ind: [35, :chief_boolean],
          amend_indicator: 1

      process(:update) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tame.insert map
        end
      }

      process(:insert) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tame.insert map
        end
      }

      process(:delete) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tame.insert map
        end
      }
    end
  end
end
