class TariffValidationMatcher
  attr_reader :subject, :attributes, :validation_type, :condition

  def initialize(validation_type)
    @validation_type = validation_type
  end

  # Check if model validation metadata constains required attributes
  def matches?(subject)
    @subject = subject.dup

    [@attributes].flatten.all? {|arg|
      validate(subject.class.validation_reflections[arg])
    } || validate(subject.class.validation_reflections[@attributes])
  end

  def of(*args)
    @attributes = [args].flatten

    self
  end

  def if(condition)
    @condition = condition

    self
  end


  def failure_message
    "expected #{subject.class.name} to validate #{validation_type} of #{attributes}"
  end

  private

  def reflection_for(attribute, type = validation_type)
    subject.class.validation_reflections[attribute]
                 .detect{|validation_type, options|
                   validation_type == type &&
                   ((condition.present?) ? options[:if] == condition : true)
                 }.try(:last)
  end

  def validate(reflections)
    reflections.detect{|validation, options|
      validation == validation_type &&
      ((condition.present?) ? options[:if] == condition : true)
    } if reflections.present?
  end
end
