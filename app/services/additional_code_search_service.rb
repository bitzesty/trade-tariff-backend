class AdditionalCodeSearchService
  attr_accessor :scope
  attr_reader :code, :description

  def initialize(attributes)
    @scope = AdditionalCode.
        actual.
        eager(:additional_code_descriptions)

    @code = attributes['code']
    @description = attributes['description']
  end

  def perform
    apply_code_filter
    apply_description_filter
    scope.all
  end

  private

  def apply_code_filter
    return if code.blank?
    self.scope = scope.where(additional_codes__additional_code: code)
  end

  def apply_description_filter
    return if description.blank?
    self.scope = scope.
      join(:additional_code_description_periods, additional_codes__additional_code_sid: :additional_code_description_periods__additional_code_sid).
      join(:additional_code_descriptions, [[:additional_code_description_periods__additional_code_description_period_sid, :additional_code_descriptions__additional_code_description_period_sid]]).
      with_actual(AdditionalCodeDescriptionPeriod).
      where(Sequel.ilike(:additional_code_descriptions__description, "#{description}%"))
  end
end
