require 'hashie'

module TradeTariffBackend
  class SearchClient < SimpleDelegator

    # Raised if Elasticsearch returns an error from query
    QueryError = Class.new(StandardError)

    attr_reader :indexed_models
    attr_reader :index_page_size
    attr_reader :search_operation_options

    delegate :search_index_for, to: TradeTariffBackend

    def initialize(search_client, options = {})
      @indexed_models = options.fetch(:indexed_models, [])
      @index_page_size = options.fetch(:index_page_size, 1000)
      @search_operation_options = options.fetch(:search_operation_options, {})

      super(search_client)
    end

    def search(*)
      Hashie::Mash.new(super)
    end

    def msearch(*)
      Hashie::Mash.new(super)
    end

    def reindex
      indexed_models.each do |model|
        search_index_for(model).tap do |index|
          drop_index(index)
          create_index(index)
          build_index(index, model)
        end
      end
    end

    def create_index(index)
      indices.create(index: index.name, body: index.definition)
    end

    def drop_index(index)
      indices.delete(index: index.name) if indices.exists(index: index.name)
    end

    def build_index(index, model)
      model.dataset.each_page(index_page_size) do |entries|
        bulk({ body: serialize_for(:index, index, entries) }.merge(search_operation_options))
      end
    end

    def index(model)
      search_index_for(model.class).tap do |model_index|
        super({
          index: model_index.name,
          type: model_index.type,
          id: model.id,
          body: TradeTariffBackend.model_serializer_for(model_index.model).new(model).as_json
        }.merge(search_operation_options))
      end
    end

    def delete(model)
      search_index_for(model.class).tap do |model_index|
        super({
          index: model_index.name,
          type: model_index.type,
          id: model.id
        }.merge(search_operation_options))
      end
    end

    private

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
