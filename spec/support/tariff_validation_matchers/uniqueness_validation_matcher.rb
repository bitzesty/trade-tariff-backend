# Uniqueness validation does not need additional checks besides
# metadata
class UniquenessValidationMatcher < TariffValidationMatcher; end

def validate_uniqueness
  UniquenessValidationMatcher.new(:uniqueness)
end
