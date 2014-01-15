class SearchIndex
  def initialize(namespace)
    @namespace = namespace
  end

  def name
    [@namespace, type].join("-")
  end

  def type
    model.to_s.underscore.pluralize
  end

  def model
    self.class.name.chomp("Index").constantize
  end
end
