class CertificateSearchService
  attr_accessor :scope
  attr_reader :code, :type, :description

  def initialize(attributes)
    @scope = Certificate.
      actual.
      eager(:certificate_descriptions, measure_conditions: [measure: :goods_nomenclature])

    @code = attributes['code']
    @type = attributes['type']
    @description = attributes['description']
  end

  def perform
    apply_code_filter if code.present?
    apply_type_filter if type.present?
    apply_description_filter if description.present?
    scope.all
  end

  private

  def apply_code_filter
    self.scope = scope.where(certificates__certificate_code: code)
  end

  def apply_type_filter
    self.scope = scope.where(certificates__certificate_type_code: type)
  end

  def apply_description_filter
    self.scope = scope.
      join(:certificate_description_periods, [[:certificates__certificate_code, :certificate_description_periods__certificate_code ],
                                              [:certificates__certificate_type_code, :certificate_description_periods__certificate_type_code]]).
      join(:certificate_descriptions, [[:certificate_description_periods__certificate_description_period_sid, :certificate_descriptions__certificate_description_period_sid]]).
      with_actual(CertificateDescriptionPeriod).
      where(Sequel.ilike(:certificate_descriptions__description, "#{description}%"))
  end
end