task add_missing_commodity_footnote: :environment do
    measure_type_id = MeasureType.all.detect { |mt| mt.description == "Export authorization (Dual use)" }.values[:measure_type_id]
    footnote = Footnote.filter(footnote_id: '002', footnote_type_id: '05').first
    Commodity.all.each do |c|
        unless c.measures.select { |m| m.measure_type_id == measure_type_id }.nil?
            f = FootnoteAssociationGoodsNomenclature.new
            f.values[:goods_nomenclature_sid] = c.values[:goods_nomenclature_sid]
            f.values[:goods_nomenclature_item_id] = c.values[:goods_nomenclature_item_id]
            f.values[:productline_suffix] = c.values[:producline_suffix]
            f.values[:validity_start_date] = c.values[:validity_start_date]
            f.values[:validity_end_date] = c.values[:validity_end_date]
            f.values[:operation] = c.values[:operation]
            f.values[:footnote_id] = footnote.values[:footnote_id]
            f.values[:footnote_type] = footnote.values[:footnote_type_id]
            f.values[:national] = footnote.values[:national]
            f.save
        end
    end
end
