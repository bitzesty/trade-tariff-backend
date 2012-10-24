RSpec::Matchers.define :validate_presence_of do |expected|
  match do |actual|
    actual.valid?

    [expected].flatten.all? {|field|
      actual.errors.keys.include?(field)
    }
  end

  failure_message_for_should do |actual|
    "expected #{actual.class.name} to validate presence of " + expected.join(", ")
  end
end
