RSpec::Matchers.define :validate_uniqueness_of do |expected|
  match do |actual|
    klass_name = actual.class.name.to_s.underscore

    record1 = create klass_name
    record2 = build  klass_name, Hash[expected, record1.send(expected)]
    !record2.valid?
  end

  failure_message_for_should do |actual|
    "expected #{actual.class.name} " + description
  end
end
