RSpec::Matchers.define :validate_validity_dates do |expected|
  match do |actual|
    klass_name = actual.class.name.to_s.underscore

    record = build klass_name, validity_start_date: Date.today.ago(1.year),
                               validity_end_date: Date.today.ago(2.years)
    !record.valid?
  end

  failure_message_for_should do |actual|
    "expected #{actual.class.name} " + description
  end
end
