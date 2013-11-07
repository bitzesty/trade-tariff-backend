attributes :id,
           :origin,
           :import,
           :goods_nomenclature_item_id

child(geographical_area: :geographical_area) do
  attributes :id

  node(:description) { |ga|
    ga.geographical_area_description.description
  }
end

node(:measure_type) { |measure|
  {
    id: measure.measure_type.id,
    description: measure.measure_type.description
  }
}
