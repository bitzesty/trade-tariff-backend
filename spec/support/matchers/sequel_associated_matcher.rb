RSpec::Matchers.define :validate_associated do |expected|
  match do |actual|
    klass_name = actual.class.name.to_s.underscore

    record = create klass_name
    associated_record = create expected.to_s.singularize.to_sym, record.pk_hash

    begin
      record.send(@callback)
      false
    rescue
      true
    end
  end

  chain :on do |callback|
    @callback = callback
  end

  failure_message_for_should do |actual|
    "#{actual.class.name} cannot be #{@callback}ed if associated #{expected} are present"
  end
end
