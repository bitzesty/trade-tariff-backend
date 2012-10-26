class AssociatedValidationMatcher < TariffValidationMatcher
  attr_reader :associated_object, :ensurance_method, :condition

  def initialize(validation_type, associated_object)
    @associated_object = associated_object

    super(validation_type)
  end

  def matches?(subject)
    @attributes = [associated_object]

    super && matches_conditions?
  end

  def if(condition)
    @condition = condition

    self
  end

  def and_ensure(ensurance_method)
    @ensurance_method = ensurance_method

    self
  end

  def failure_message
    "expected #{subject.class.name} to validate #{validation_type} #{associated_object} and ensure that #{ensurance_method} is truthy"
  end

  private

  def matches_conditions?
    attributes.all? {|attribute|
      reflection_for(attribute)[:if] == condition if condition.present?
      reflection_for(attribute)[:ensure] == ensurance_method if ensurance_method.present?
    }
  end
end

def validate_associated(associated_object)
  AssociatedValidationMatcher.new(:associated, associated_object)
end
