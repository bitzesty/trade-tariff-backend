RSpec::Matchers.define :validate do |expected_validation|
  match do |model|
    # try validating args separately or in group for e.g. uniqueness
    [@args].flatten.all? {|arg|
      validate(model.class.validation_reflections[arg])
    } || validate(model.class.validation_reflections[@args])
  end

  def validate(reflections)
    reflections.tap{|reflections|
      reflections.detect{|validation, opts|
        validation == @expected_validation
      } if reflections.present?
    }
  end

  chain :of do |args|
    @args = args
  end

  failure_message_for_should do |model|
    if @args.present?
      "expected #{actual.class.name} to validate #{expected_validation} of #{@args}"
    else
      "expected #{actual.class.name} to validate #{expected_validation} of #{model.class.name}"
    end
  end
end
