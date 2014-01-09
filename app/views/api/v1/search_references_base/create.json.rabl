object @search_reference

attributes :id, :title, :referenced, :referenced_id, :referenced_class

node(false) { |search_reference|
  partial("api/v1/search_references_base/#{search_reference.referenced_class.underscore}", object: :referenced)
}
