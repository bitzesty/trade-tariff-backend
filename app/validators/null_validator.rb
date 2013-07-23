# If oplog class has no associated validator class
# NullValidator will take its place and perform no validations
class NullValidator
  def self.validate(record)
  end

  def self.validate_for_operations(*)
  end

  def self.validations
    []
  end
end
