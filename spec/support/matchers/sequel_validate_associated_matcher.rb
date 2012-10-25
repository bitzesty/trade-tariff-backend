RSpec::Matchers.define :validate_associated do |association, opts = {}|
  match do |model|
    validations = model.class.validation_reflections[association]
    if validations.present?
      validation_type, @validation_opts = validations.detect{ |k,opts| k == :associated }
      validation_type.present? && @validation_opts.has_key?(:ensure)
    end
  end

  failure_message_for_should do
    if !@validation_opts.nil? && !@validation_opts.has_key?(:ensure)
      "expected #{actual.class.name} to validate associated #{association.to_s.humanize}, :ensure block not provided"
    else
      "expected #{actual.class.name} to validate associated #{association.to_s.humanize}"
    end
  end
end
