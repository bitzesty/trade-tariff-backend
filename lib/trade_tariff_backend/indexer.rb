module TradeTariffBackend
  module Indexer
    extend self

    def run
      drop_indexes
      reindex_models
      delete_hidden_goods_nomenclatures
    end

    private

    def drop_indexes
      # mark for Tire that it should delete indexes
      ENV['FORCE'] = 'true'
    end

    def reindex_models
      TimeMachine.with_relevant_validity_periods do
        ['Section','Chapter','Heading','Commodity','SearchReference'].each do |klass|
          ENV['CLASS'] = klass
          Rake::Task['tire:import'].execute
        end
      end
    end

    def delete_hidden_goods_nomenclatures
      GoodsNomenclature.where(goods_nomenclature_item_id: HiddenGoodsNomenclature.codes).all.each do |gono|
        gono.class.tire.index.remove gono
      end
    end
  end
end
