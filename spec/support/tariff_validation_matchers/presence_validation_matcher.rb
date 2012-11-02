# Presence validation does not need additional checks besides
# metadata
class PresenceValidationMatcher < TariffValidationMatcher
  def failure_message
    msg = "expected #{subject.class.name} to validate #{validation_type} of #{attributes}"
    msg << " if #{condition} is true" if condition.present?
    msg
  end
end

def validate_presence
  PresenceValidationMatcher.new(:presence)
end
