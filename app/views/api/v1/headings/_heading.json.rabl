attributes :goods_nomenclature_sid, :goods_nomenclature_item_id, :declarable, :description, :producline_suffix, :leaf

node(:children) { |heading|
  heading.children.map do |heading|
    partial("api/v1/headings/heading", object: heading)
  end
}
