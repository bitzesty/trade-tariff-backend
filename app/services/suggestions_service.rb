class SuggestionsService
  def to_json(config = {})
    perform.to_json
  end

  private

  def perform
    a = Commodity.select(:goods_nomenclature_item_id)
                 .actual
                 .order(Sequel.desc(:goods_nomenclature_item_id))
                 .map{ |i| { value: i.goods_nomenclature_item_id } }

    b = SearchReference.select(:title)
                       .order(Sequel.desc(:title))
                       .map{ |i| { value: i.title } }

    c = CasNumber.select(:title)
                 .order(Sequel.desc(:title))
                 .map{ |i| { value: i.title } }

    [a, b, c].flatten.compact.uniq
  end
end
