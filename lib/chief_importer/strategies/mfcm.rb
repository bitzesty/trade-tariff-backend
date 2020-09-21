class ChiefImporter
  module Strategies
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
          exports_use_ind: [12, :chief_boolean],
          amend_indicator: 1

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
            Chief::Mfcm.insert map
        end
      }

      process(:delete) {
        if (prohibition_or_restriction?(map[:msrgp_code]) ||
            vat_or_excise?(map[:msrgp_code])) &&
            !excluded_measure?(map[:msrgp_code], map[:msr_type])
            Chief::Mfcm.insert map
        end
      }
    end
  end
end
