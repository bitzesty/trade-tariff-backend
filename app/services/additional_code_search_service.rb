class AdditionalCodeSearchService
  attr_accessor :scope
  attr_reader :code, :description

  def initialize(attributes)
    self.scope = AdditionalCode.
        actual.
        eager(:additional_code_descriptions)

    @code = attributes['code']
    @description = attributes['description']
  end

  def perform
    apply_code_filter if code.present?
    apply_description_filter if description.present?
    scope.all
  end

  private

  def apply_code_filter
    self.scope = scope.where(additional_codes__additional_code: code)
  end

  def apply_description_filter
    self.scope = scope.
      join(:additional_code_description_periods, additional_codes__additional_code_sid: :additional_code_description_periods__additional_code_sid).
      join(:additional_code_descriptions, [[:additional_code_description_periods__additional_code_description_period_sid, :additional_code_descriptions__additional_code_description_period_sid]]).
      with_actual(AdditionalCodeDescriptionPeriod).
      where(Sequel.ilike(:additional_code_descriptions__description, "#{description}%"))
  end
end
