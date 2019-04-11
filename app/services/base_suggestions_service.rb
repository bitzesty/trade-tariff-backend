class BaseSuggestionsService
  def to_json(_config = {})
    perform.to_json
  end
  
  def perform
    a = Commodity.select(:goods_nomenclature_sid, :goods_nomenclature_item_id)
          .actual
          .distinct
          .order(Sequel.desc(:goods_nomenclature_item_id))
          .map { |i| handle_commodity_record(i) }
  
    b = SearchReference.select(:id, :title)
          .distinct
          .order(Sequel.desc(:title))
          .map { |i| handle_search_reference_record(i)}
    [a, b].flatten.compact
  end

  protected

  def handle_commodity_record(_commodity)
    nil
  end

  def handle_search_reference_record(_search_reference)
    nil
  end
end
