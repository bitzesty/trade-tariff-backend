class ChiefImporter
  module Strategies
    class Tbl9 < BaseStrategy
      map fe_tsmp: [0, :chief_date],
          amend_indicator: 1,
          tbl_type: [2, :chief_string],
          tbl_code: [3, :chief_string],
          txtlnno: 4,
          tbl_txt: [6, :chief_string]

      process(:update) {
        Chief::Tbl9.insert(map)
      }

      process(:insert) {
        Chief::Tbl9.insert(map)
      }

      process(:delete) {
        Chief::Tbl9.insert(map)
      }
    end
  end
end
