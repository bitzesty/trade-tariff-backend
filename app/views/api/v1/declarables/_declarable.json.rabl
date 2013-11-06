node(:declarable) { true }

attributes :meursing_code

child :section do
  attributes :title, :position, :numeral
end

child :chapter do
  attributes :goods_nomenclature_item_id, :description, :formatted_description
end

child :footnote do
  attributes :code, :description, :formatted_description
end

node(:import_measures) { |declarable|
  locals[:measures].select(&:import).map do |import_measure|
    partial "api/v1/measures/measure", object: import_measure, locals: { declarable: declarable }
  end
}

node(:export_measures) { |declarable|
  locals[:measures].select(&:export).map do |export_measure|
    partial "api/v1/measures/_measure", object: export_measure, locals: { declarable: declarable }
  end
}
