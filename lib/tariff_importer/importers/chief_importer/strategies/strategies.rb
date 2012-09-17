class ChiefImporter
  module Strategies
    class TAME < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: 2,
          msr_type: 3,
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          le_tsmp: [6, :chief_date],
          adval_rate: 8,
          alch_sgth: 9,
          audit_tsmp: [10, :chief_date],
          cap_ai_stmt: 11,
          cap_max_pct: 12,
          cmdty_msr_xhdg: 13,
          comp_mthd: 14,
          cpc_wvr_phb: 15,
          ec_msr_set: 16,
          mip_band_exch: 17,
          mip_rate_exch: 18,
          mip_uoq_code: 19,
          nba_id: 20,
          null_tri_rqd: 21,
          qta_code_uk: 22,
          qta_elig_use: 23,
          qta_exch_rate: 24,
          qta_no: 25,
          qta_uoq_code: 26,
          rfa: 27,
          rfs_code_1: 28,
          rfs_code_2: 29,
          rfs_code_3: 30,
          rfs_code_4: 31,
          rfs_code_5: 32,
          tdr_spr_sur: 33,
          exports_use_ind: 34

      process(:update) { Chief::Tame.insert map }
      process(:insert) { Chief::Tame.insert map }
    end

    class TAMF < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: [2, :chief_string],
          msr_type: [3, :chief_string],
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          le_tsmp: [6, :chief_date],
          adval1_rate: [8, :chief_decimal],
          adval2_rate: [9, :chief_decimal],
          ai_factor: [10, :chief_string],
          cmdty_dmql: [11, :chief_decimal],
          cmdty_dmql_uoq: [12, :chief_string],
          cngp_code: [13, :chief_string],
          cntry_disp: [14, :chief_string],
          cntry_orig: [15, :chief_string],
          duty_type: [16, :chief_string],
          ec_supplement: [17, :chief_string],
          ec_exch_rate: [18, :chief_string],
          spcl_inst: [19, :chief_string],
          spfc1_cmpd_uoq: [20, :chief_string],
          spfc1_rate: [21, :chief_decimal],
          spfc1_uoq: [22, :chief_string],
          spfc2_rate: [23, :chief_decimal],
          spfc2_uoq: [24, :chief_string],
          spfc3_rate: [25, :chief_decimal],
          spfc3_uoq: [26, :chief_string],
          tamf_dt: [27, :chief_string],
          tamf_sta: [28, :chief_string],
          tamf_ty: [29, :chief_string]

      process(:update) { Chief::Tamf.insert map }
      process(:insert) { Chief::Tamf.insert map }
    end

    class MFCM < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: 2,
          msr_type: 3,
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          le_tsmp: [6, :chief_date],
          audit_tsmp: [8, :chief_date],
          cmdty_code: [9, :chief_code],
          cmdty_msr_xhdg: [10, :chief_string],
          null_tri_rqd: [11, :chief_string],
          exports_use_ind: 12

      process(:insert) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Mfcm.insert map
        end
      }

      process(:update) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
            # TODO FIND AND UPDATE
            # binding.pry
            Chief::Mfcm.insert map
        end
      }
    end
  end
end
