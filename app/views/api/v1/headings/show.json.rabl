object @heading

attributes :goods_nomenclature_item_id, :description

if @heading.declarable?
  extends "api/v1/declarables/declarable", object: @heading
else
  child :chapter do
    attributes :goods_nomenclature_item_id, :description
  end

  child :section do
    attributes :title, :numeral, :position
  end

  node(:commodities) {
    @commodities.map do |commodity|
      partial("api/v1/commodities/commodity", object: commodity)
    end
  }
end
