# Presence validation does not need additional checks besides
# metadata
class PresenceValidationMatcher < TariffValidationMatcher; end

def validate_presence
  PresenceValidationMatcher.new(:presence)
end
