class TariffValidationMatcher
  attr_reader :subject, :attributes, :validation_type, :condition, :validation

  def initialize(validation_type)
    @validation_type = validation_type
  end

  # Check if model validation metadata constains required attributes
  def matches?(subject)
    @subject = subject.dup

    @validation = subject.conformance_validator
                         .validations
                         .detect{|validation| validation.type == validation_type }
  end

  def of(arg)
    @attributes = arg

    self
  end

  def if(condition)
    @condition = condition

    self
  end

  def description
    "validate #{validation_type} of #{attributes}"
  end

  def failure_message
    "expected #{subject.class.name} to validate #{validation_type} of #{attributes}"
  end
end
