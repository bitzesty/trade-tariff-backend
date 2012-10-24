RSpec::Matchers.define :span_validity_date_of do |expected|
  match do |actual|
    actual.validity_start_date >= actual.send(expected).validity_start_date &&
    (actual.validity_end_date.blank? || (actual.validity_end_date <= actual.send(expected).validity_end_date))
  end

  failure_message_for_should do |actual|
    "expected #{actual.class.name} to span validity dates of associated #{expected.to_s.humanize}"
  end
end
