collection @sections
attributes :id

child(chapters: :chapters) do
  attributes :goods_nomenclature_item_id
  child(headings: :headings) do
    attributes :goods_nomenclature_item_id,
               :declarable
  end
end
