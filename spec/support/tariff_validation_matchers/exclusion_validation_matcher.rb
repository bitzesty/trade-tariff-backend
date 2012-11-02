class ExclusionValidationMatcher < TariffValidationMatcher
  attr_reader :collection

  def matches?(subject)
    super && matches_collection?
  end

  def from(collection)
    @collection = collection

    self
  end

  def failure_message
    msg = "expected #{subject.class.name} to validate #{validation_type} of #{attributes}"
    msg << " from #{collection}" if collection.present?
    msg
  end

  private

  def matches_collection?
    if collection.present?
      reflection_for(attributes.first)[:from] == collection
    else
      true
    end
  end
end

def validate_exclusion
  ExclusionValidationMatcher.new(:exclusion)
end
