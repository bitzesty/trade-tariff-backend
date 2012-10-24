RSpec::Matchers.define :validate_uniqueness_of do |expected|
  match do |actual|
    klass_name = actual.class.name.to_s.underscore
    expected_attributes = [expected].flatten
    record1 = create klass_name

    similarity_hash = expected_attributes.inject({}) { |memo, attribute|
      memo.merge!(Hash[attribute, record1.send(attribute)])
      memo
    }

    record2 = build  klass_name, similarity_hash
    !record2.valid?
  end

  failure_message_for_should do |actual|
    "expected #{actual.class.name} " + description
  end
end
