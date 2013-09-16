object @search_reference

attributes :id, :title, :referenced_entity

node(false) { |search_reference|
  partial("api/v1/search_references/#{search_reference.referenced_entity.class.name.underscore}", object: :referenced_entity)
}
