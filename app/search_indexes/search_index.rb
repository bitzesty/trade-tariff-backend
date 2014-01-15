class SearchIndex
  def initialize(namespace)
    @namespace = namespace
  end

  def name
    [@namespace, self.class.name.chomp("Index").underscore.pluralize].join("-")
  end
end
