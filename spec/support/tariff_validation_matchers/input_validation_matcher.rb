class InputValidationMatcher < TariffValidationMatcher
  attr_reader :condition

  def matches?(subject)
    super && matches_collection?
  end

  def failure_message
    msg = "expected #{subject.class.name} to validate #{validation_type} of #{attributes}"
    msg << " and require #{condition} to return true" if condition.present?
    msg
  end

  def requires(condition)
    @condition = condition

    self
  end

  private

  def matches_collection?
    if condition.present?
      attributes.all? {|attribute|
        reflection_for(attribute)[:requires] == condition
      }
    else
      true
    end
  end
end

def validate_input
  InputValidationMatcher.new(:input)
end
