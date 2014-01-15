require 'hashie'

module TradeTariffBackend
  class SearchClient < SimpleDelegator
    attr_reader :indexed_models
    attr_reader :namespace
    attr_reader :index_page_size

    def initialize(search_client, options = {})
      @indexed_models = options.fetch(:indexed_models, [])
      @namespace = options.fetch(:namespace, '')
      @index_page_size = options.fetch(:index_page_size, 1000)

      super(search_client)
    end

    def search(*)
      Hashie::Mash.new(super)
    end

    def reindex
      indexed_models.each do |model|
        search_index_for(model).tap do |index|
          drop_index(index.name)
          create_index(index.name, index.definition)
          build_index(index, model)
        end
      end
    end

    def create_index(index_name, index_definition)
      indices.create(index: index_name, body: index_definition)
    end

    def drop_index(index_name)
      indices.delete(index: index_name) if indices.exists(index: index_name)
    end

    def build_index(index, model)
      model.dataset.each_page(index_page_size) do |entries|
        bulk(body: serialize_for(:index, index, entries))
      end
    end

    private

    def search_index_for(model)
      "#{model}Index".constantize.new(namespace)
    end

    def serialize_for(operation, index, entries)
      entries.each_with_object([]) do |model, memo|
        memo.push(
          {
            operation => {
              _index: index.name,
              _type: index.type,
              _id: model.id,
              data: TradeTariffBackend.model_serializer_for(index.model).new(model).as_json
            }
          }
        )
      end
    end
  end
end
