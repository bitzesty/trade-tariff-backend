class ValidityDateMatcher < TariffValidationMatcher
  def description
    "validate validity dates of #{@subject.class.name}"
  end

  def failure_message
    "expected #{@subject.class.name} to validate validity dates"
  end
end

def validate_validity_dates
  ValidityDateMatcher.new(:validity_dates)
end
