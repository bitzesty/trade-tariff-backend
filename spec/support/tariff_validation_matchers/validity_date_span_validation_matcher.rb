class ValidityDateSpanMatcher < TariffValidationMatcher
  def matches?(subject)
    super

    subject.conformance_validator
           .validations
           .select{|validation| validation.type == validation_type }
           .any?{|validation|
      validation.validation_options[:of] == @attributes
    }
  end
end

def validate_validity_date_span
  ValidityDateSpanMatcher.new(:validity_date_span)
end
