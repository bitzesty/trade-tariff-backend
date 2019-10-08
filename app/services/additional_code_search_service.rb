class AdditionalCodeSearchService
  attr_accessor :scope
  attr_reader :code, :type, :description, :current_page, :per_page

  delegate :pagination_record_count, to: :scope

  def initialize(attributes, current_page, per_page)
    self.scope = AdditionalCode.
        actual.
        eager(:additional_code_descriptions).
        order(:additional_codes__additional_code_type_id, :additional_codes__additional_code)

    @code = attributes['code']
    @code = @code[1..-1] if @code&.length == 4
    @type = attributes['type']
    @description = attributes['description']
    @current_page = current_page
    @per_page = per_page
  end

  def perform
    apply_code_filter if code.present?
    apply_type_filter if type.present?
    apply_description_filter if description.present?
    self.scope = scope.paginate(current_page, per_page)
    scope.to_a
  end

  private

  def apply_code_filter
    self.scope = scope.where(additional_codes__additional_code: code)
  end

  def apply_type_filter
    self.scope = scope.where(additional_codes__additional_code_type_id: type)
  end

  def apply_description_filter
    self.scope = scope.
      join(:additional_code_description_periods, additional_codes__additional_code_sid: :additional_code_description_periods__additional_code_sid).
      join(:additional_code_descriptions, [[:additional_code_description_periods__additional_code_description_period_sid, :additional_code_descriptions__additional_code_description_period_sid]]).
      with_actual(AdditionalCodeDescriptionPeriod).
      where(Sequel.ilike(:additional_code_descriptions__description, "#{description}%"))
  end
end
