object @search_reference

attributes :id, :title, :referenced_id, :referenced_class

child :referenced => :referenced do |referenced|
  partial("api/v1/search_references_base/#{referenced.class.to_s.underscore}", object: :referenced)
end
