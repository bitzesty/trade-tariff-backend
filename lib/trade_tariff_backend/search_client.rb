require 'hashie'

module TradeTariffBackend
  class SearchClient < SimpleDelegator
    attr_reader :indexed_models
    attr_reader :namespace

    def initialize(search_client, options = {})
      @indexed_models = options.fetch(:indexed_models, [])
      @namespace = options.fetch(:namespace, '')

      super(search_client)
    end

    def search(*)
      Hashie::Mash.new(super)
    end

    def reindex
      drop_indexes
      create_indexes
      index
    end

    def create_indexes
      indexed_models.each do |model|
        search_index_for(model).tap do |index|
          create_index(index.name, index.definition) unless indices.exists(index: index.name)
        end
      end
    end

    def create_index(index_name, index_definition)
      indices.create index: index_name, body: index_definition
    end

    def drop_indexes
      indexed_models.each do |model|
        search_index_for(model).tap do |index|
          indices.delete(index: index.name) if indices.exists(index: index.name)
        end
      end
    end

    def index
    end

    private

    def search_index_for(model)
      "#{model}Index".constantize.new(namespace)
    end
  end
end
