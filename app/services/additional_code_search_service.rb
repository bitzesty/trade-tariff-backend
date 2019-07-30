class AdditionalCodeSearchService
  attr_reader :scope

  def initialize(attributes)
    @scope = AdditionalCode.
        actual.
        eager(:additional_code_descriptions)

    if attributes.present?
      attributes.each do |name, value|
        send(:"#{name}=", value) if self.respond_to?(:"#{name}=") && value.present?
      end
    end
  end

  def code=(value)
    @scope = scope.where(additional_codes__additional_code: value)
  end

  def description=(value)
    @scope = scope.
        join(:additional_code_description_periods, additional_codes__additional_code_sid: :additional_code_description_periods__additional_code_sid).
        join(:additional_code_descriptions, [[:additional_code_description_periods__additional_code_description_period_sid, :additional_code_descriptions__additional_code_description_period_sid]]).
        with_actual(AdditionalCodeDescriptionPeriod).
        where(Sequel.ilike(:additional_code_descriptions__description, "#{value}%"))
  end

  def perform
    scope.all
  end
end
