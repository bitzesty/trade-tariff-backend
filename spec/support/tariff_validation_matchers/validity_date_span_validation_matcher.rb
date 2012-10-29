class ValidityDateSpanMatcher < TariffValidationMatcher; end

def validate_validity_date_span
  ValidityDateSpanMatcher.new(:validity_date_span)
end
