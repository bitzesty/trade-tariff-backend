Sequel.migration do
  CODES =
    ["9900000000",
     "9905000000",
     "9905000000",
     "9919000000",
     "9930000000",
     "9930240000",
     "9930270000",
     "9930990000",
     "9931000000",
     "9931240000",
     "9931270000",
     "9931990000",
     "9950000000"]

  up do
    CODES.each do |code|
      HiddenGoodsNomenclature.create(goods_nomenclature_item_id: code)
    end
  end

  down do
    CODES.each do |code|
      HiddenGoodsNomenclature.where(goods_nomenclature_item_id: code)
                             .delete
    end
  end
end
