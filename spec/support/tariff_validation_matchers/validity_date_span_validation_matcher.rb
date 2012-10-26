class ValidityDateSpanMatcher < TariffValidationMatcher
  include Mocha::API

  def matches?(subject)
    super #&& matches_in_integration?
  end

  # def matches_in_integration?
  #   subject.stubs(validity_start_date: Time.now.ago(10.hours),
  #                validity_end_date: Time.now.in(10.hours))

  #   attributes.each do |attribute|
  #     associated_object_stub = stub_everything(validity_start_date: Time.now.ago(1.hour),
  #                                              validity_end_date: Time.now.in(1.hour),
  #                                              sql_literal: attribute.to_s)

  #     subject.stubs(attribute).returns(associated_object_stub)
  #   end

  #   !subject.valid? && subject.errors
  #                             .values_at(*attributes)
  #                             .flatten
  #                             .select
  #                             .select{|e| e =~ /span/ }.size >= attributes.size
  # end
end

def validate_validity_date_span
  ValidityDateSpanMatcher.new(:validity_date_span)
end
