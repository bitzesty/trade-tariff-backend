class ChiefImporter
  module Strategies
    class TAMF < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          msrgp_code: [2, :chief_string],
          msr_type: [3, :chief_string],
          tty_code: [4, :chief_string],
          tar_msr_no: [5, :chief_code],
          adval1_rate: [7, :chief_decimal],
          adval2_rate: [8, :chief_decimal],
          ai_factor: [9, :chief_string],
          cmdty_dmql: [10, :chief_decimal],
          cmdty_dmql_uoq: [11, :chief_string],
          cngp_code: [12, :chief_string],
          cntry_disp: [13, :chief_string],
          cntry_orig: [14, :chief_string],
          duty_type: [15, :chief_string],
          ec_supplement: [16, :chief_string],
          ec_exch_rate: [17, :chief_string],
          spcl_inst: [18, :chief_string],
          spfc1_cmpd_uoq: [19, :chief_string],
          spfc1_rate: [20, :chief_decimal],
          spfc1_uoq: [21, :chief_string],
          spfc2_rate: [22, :chief_decimal],
          spfc2_uoq: [23, :chief_string],
          spfc3_rate: [24, :chief_decimal],
          spfc3_uoq: [25, :chief_string],
          tamf_dt: [26, :chief_string],
          tamf_sta: [27, :chief_string],
          tamf_ty: [28, :chief_string],
          amend_indicator: 1

      process(:update) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tamf.insert map
        end
      }
      process(:insert) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tamf.insert map
        end
      }
      process(:delete) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
          Chief::Tamf.insert map
        end
      }
    end
  end
end
