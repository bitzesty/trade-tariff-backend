class SuggestionsService
  def to_json(_config = {})
    perform.to_json
  end

private

  def perform
    a = Commodity.select(:goods_nomenclature_item_id)
                 .actual
                 .distinct
                 .order(Sequel.desc(:goods_nomenclature_item_id))
                 .map { |i| { value: i.goods_nomenclature_item_id } }

    b = SearchReference.select(:title)
                       .distinct
                       .order(Sequel.desc(:title))
                       .map { |i| { value: i.title } }
    [a, b].flatten.compact
  end
end
