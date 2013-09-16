# Thin wrapper around Tire to avoid using ActiveSupport Callbacks which are not
# supported by Sequel

module TradeTariffBackend
  class SearchIndex
    def self.for(model)
      new(model) if model.kind_of?(Tire::Model::Search)
    end

    def initialize(model)
      @model = model
    end

    def store
      @model.tire.index.store(@model, { percolate: @model.tire.percolator })
    end

    def remove
      @model.tire.index.remove @model
    end
  end
end
