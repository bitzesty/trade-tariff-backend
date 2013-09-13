attributes :measure_sid,
           :origin,
           :import,
           :goods_nomenclature_item_id

child(geographical_area: :geographical_area) do
  attributes :geographical_area_id

  node(:description) { |ga|
    ga.geographical_area_description.description
  }
end

node(:measure_type_description) { |obj|
  obj.measure_type.try(:description)
}
