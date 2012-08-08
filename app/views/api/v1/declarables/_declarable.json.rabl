node(:declarable) { true }

child :section do
  attributes :title, :position, :numeral
end

child :chapter do
  attributes :goods_nomenclature_item_id, :description
end

node(:import_measures) { |declarable|
  @import_measures.map do |import_measure|
    partial "api/v1/measures/measure", object: import_measure
  end
}

node(:export_measures) { |declarable|
  @export_measures.map do |export_measure|
    partial "api/v1/measures/_measure", object: export_measure
  end
}
