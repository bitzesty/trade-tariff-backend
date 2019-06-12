module HeadingService
  class CachedHeadingService
    
    attr_reader :heading, :as_of, :result
    
    def initialize(heading, as_of)
      @heading = heading
      @as_of = as_of
    end
    
    def serializable_hash
      @result = fetch_result || serialize_result
      if result.present? && as_of.present?
        filter_chapter
        filter_footnotes
        filter_commodities
        filter_commodity_relations
        build_commodities_tree
      end
      result
    end
    
    private
    
    def serialize_result
      ::Hashie::Mash.new(::Cache::HeadingSerializer.new(heading).as_json)
    end
    
    def fetch_result
      search_client = ::TradeTariffBackend.search_client
      index = ::Cache::HeadingIndex.new(TradeTariffBackend.search_namespace).name
      result = search_client.search index: index, body: {query: {match: {_id: heading.goods_nomenclature_sid}}}
      result&.hits&.hits&.first&._source
    end
    
    def filter_chapter
      result.delete(:chapter) if result.chapter.present? && !has_valid_dates(result.chapter)
      result.chapter_id = result.chapter&.goods_nomenclature_sid
    end
    
    def filter_footnotes
      result.footnotes.keep_if do |footnote|
        has_valid_dates(footnote)
      end
      result.footnote_ids = result.footnotes.map do |footnote|
        footnote.footnote_id
      end
    end
    
    def filter_commodities
      result.commodities.keep_if do |commodity|
        has_valid_dates(commodity)
      end
      result.commodity_ids = result.commodities.map do |commodity|
        commodity.goods_nomenclature_sid
      end
    end
    
    def filter_commodity_relations
      result.commodities.each do |commodity|
        commodity.overview_measures.keep_if do |measure|
          has_valid_dates(measure, :effective_start_date, :effective_end_date)
        end
        
        commodity.overview_measures = OverviewMeasurePresenter.new(commodity.overview_measures, commodity).validate!
        
        commodity.overview_measure_ids = commodity.overview_measures.map do |measure|
          measure.measure_sid
        end
        
        commodity.goods_nomenclature_indents.keep_if do |ident|
          has_valid_dates(ident)
        end
        
        indent = commodity.goods_nomenclature_indents.sort_by do |ident|
          Date.parse ident.validity_start_date
        end.last
        
        commodity.number_indents = indent.number_indents
        commodity.producline_suffix = indent.productline_suffix
        
        commodity.goods_nomenclature_descriptions.keep_if do |description|
          has_valid_dates(description)
        end
        
        description = commodity.goods_nomenclature_descriptions.sort_by do |description|
          Date.parse description.validity_start_date
        end.last
        
        commodity.description = description.description
        commodity.formatted_description = description.formatted_description
        commodity.description_plain = description.description_plain
        
        commodity.leaf = true
      end
    end
    
    def has_valid_dates(hash, start_key = :validity_start_date, end_key = :validity_end_date)
      hash[start_key].to_date <= as_of &&
        (hash[end_key].nil? || hash[end_key].to_date >= as_of)
    end
    
    attr_reader :parent_map, :commodity_index
    
    def build_commodities_tree
      @parent_map = {}
      @commodity_index = result.commodities.each_with_index.map do |commodity, index|
        {commodity.goods_nomenclature_sid => index}
      end.reduce({}, :merge)
      traverse(result.commodities.first)
    end
    
    def traverse(first_goods_nomenclature)
      # ignore case when first goods_nomenclature is blank it's a direct child of the heading
      unless result.commodities.index(first_goods_nomenclature).blank?
        next_goods_nomenclature = result.commodities[result.commodities.index(first_goods_nomenclature) + 1]
        if next_goods_nomenclature.present? # we are not at the end of the goods_nomenclature array
          map_goods_nomenclatures(first_goods_nomenclature, next_goods_nomenclature)
          traverse(next_goods_nomenclature)
        end
      end
    end
    
    def map_goods_nomenclatures(primary, secondary)
      if primary.number_indents < secondary.number_indents
        
        primary.leaf = false
        secondary.parent_sid = primary.goods_nomenclature_sid
        parent_map[secondary.goods_nomenclature_sid] = primary.goods_nomenclature_sid
        
      elsif primary.number_indents == secondary.number_indents
        
        if primary.parent_sid.present? # if primary is not directly under heading
          parent = find_commodity(primary.parent_sid)
          parent.leaf = false
          secondary.parent_sid = parent.goods_nomenclature_sid
          parent_map[secondary.goods_nomenclature_sid] = parent.goods_nomenclature_sid
        end
        
      else
        
        parent = nth_parent(primary, secondary.number_indents)
        if parent.present?
          parent.leaf = false
          secondary.parent_sid = parent.goods_nomenclature_sid
          parent_map[secondary.goods_nomenclature_sid] = parent.goods_nomenclature_sid
        end
        
      end
    end
    
    def nth_parent(goods_nomenclature, nth)
      if nth > 0
        goods_nomenclature = find_commodity(goods_nomenclature.parent_sid)
        
        while goods_nomenclature.present? && goods_nomenclature.number_indents >= nth
          goods_nomenclature = parent_of(goods_nomenclature)
        end
        
        goods_nomenclature
      end
    end
    
    def parent_of(goods_nomenclature)
      find_commodity(parent_map[goods_nomenclature.goods_nomenclature_sid])
    end
    
    def find_commodity(goods_nomenclature_sid)
      index = commodity_index[goods_nomenclature_sid]
      result.commodities[index] if index.present?
    end
  end
end