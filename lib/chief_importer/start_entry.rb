class ChiefImporter < TariffImporter
  class StartEntry
    attr_reader :table, :fe_tsmp, :amend_indicator, :extraction_date

    # [Table identifier, FE-TSMP, AMEND-INDICATOR, date of extraction]
    def initialize(attributes = [nil, nil, nil, nil])
      @table, @fe_tsmp, @amend_indicator = attributes
      @extraction_date = Date.parse(attributes[3])
    end
  end
end
