class ValidityDateMatcher < TariffValidationMatcher
  def matches?(subject)
    @attributes = [:validity_start_date, :validity_end_date]

    super && matches_in_integration?
  end

  def description
    "validate validity dates of #{@subject.class.name}"
  end


  def matches_in_integration?
    subject.validity_start_date = Time.now.in(10.minutes)
    subject.validity_end_date = Time.now.ago(10.minutes)

    !subject.valid? subject.errors
                           .values_at(*attributes)
                           .flatten
                           .select
                           .select{|e| e =~ /end date/ }.size >= attributes.size
  end

  def failure_message
    "expected #{@subject.class.name} to validate validity dates"
  end
end

def validate_validity_dates
  ValidityDateMatcher.new(:validity_date)
end
