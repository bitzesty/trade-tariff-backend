class CertificateSearchService
  attr_accessor :scope
  attr_reader :code, :description

  def initialize(attributes)
    @scope = Certificate.
      actual.
      eager(:certificate_descriptions, measure_conditions: [measure: :goods_nomenclature])

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
    self.scope = scope.where(certificates__certificate_code: code)
  end

  def apply_description_filter
    return if description.blank?
    self.scope = scope.
      join(:certificate_description_periods, [[:certificates__certificate_code, :certificate_description_periods__certificate_code ],
                                              [:certificates__certificate_type_code, :certificate_description_periods__certificate_type_code]]).
      join(:certificate_descriptions, [[:certificate_description_periods__certificate_description_period_sid, :certificate_descriptions__certificate_description_period_sid]]).
      with_actual(CertificateDescriptionPeriod).
      where(Sequel.ilike(:certificate_descriptions__description, "#{description}%"))
  end
end