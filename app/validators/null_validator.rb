# If oplog class has no associated validator class
# NullValidator will take its place and perform no validations
class NullValidator
  def self.validate(record, active_validations  = [])
  end

  def self.validations
    []
  end
end
