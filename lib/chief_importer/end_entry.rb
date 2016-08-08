class ChiefImporter
  class EndEntry
    attr_reader :table, :fe_tsmp, :amend_indicator, :record_count

    # [table identifier, fe-tsmp, amend-indicator, record count]
    def initialize(attributes = [nil, nil, nil, 0])
      @table, @fe_tsmp, @amend_indicator = attributes
      @record_count = attributes[3].to_i
    end
  end
end
