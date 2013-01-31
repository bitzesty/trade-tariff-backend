node(:declarable) { true }

child :section do
  attributes :title, :position, :numeral
end

child :chapter do
  attributes :goods_nomenclature_item_id, :description
end

child :footnote do
  attributes :code
  node(:description) { |footnote|
   footnote.footnote_description.description
  }
end

child national_measurement_unit_set_units: :national_measurement_units do
  attributes :level, :measurement_unit_code, :description
end

node(:import_measures) { |declarable|
  @measures.select(&:import).map do |import_measure|
    partial "api/v1/measures/measure", object: import_measure
  end
}

node(:export_measures) { |declarable|
  @measures.select(&:export).map do |export_measure|
    partial "api/v1/measures/_measure", object: export_measure
  end
}
