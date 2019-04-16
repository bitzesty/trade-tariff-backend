class QuotaSearchService

  attr_reader :scope, :as_of, :status
  
  def initialize(attributes)
    @scope = QuotaDefinition.
      eager(:quota_exhaustion_events, :quota_blocking_periods, quota_order_number: [quota_order_number_origin: :geographical_area]).
      distinct(:quota_definitions__quota_definition_sid).
      select(Sequel.expr(:quota_definitions).*).
      join(:quota_order_numbers, quota_order_numbers__quota_order_number_sid: :quota_definitions__quota_order_number_sid).
      join(:quota_order_number_origins, quota_order_numbers__quota_order_number_sid: :quota_order_number_origins__quota_order_number_sid)
    
    if attributes.present?
      attributes.each do |name, value|
        send(:"#{name}=", value) if self.respond_to?(:"#{name}=") && value.present?
      end
    end
  end
  
  def geographical_area_id=(value)
    @scope = scope.where(quota_order_number_origins__geographical_area_id: value)
  end
  
  def order_number=(value)
    @scope = scope.where(Sequel.like(:quota_order_numbers__quota_order_number_id, "#{value}%"))
  end
  
  def critical=(value)
    @scope = scope.where(quota_definitions__critical_state: value)
  end
  
  def year=(value)
    @scope = scope.where("EXTRACT(YEAR FROM quota_definitions.validity_start_date) IN (#{Array.wrap(value).join(', ')})")
  end
  
  def status=(value)
    @status = value.downcase.tr(' ', '_')
  end
  
  def perform
    result = scope.all
    apply_status_filters(result)
  end

  private
  
  def apply_status_filters(quotas)
    return quotas unless quotas.present? && status.present?
    send("apply_#{status}_filter", quotas)
  end
  
  def apply_exhausted_filter(quotas)
    quotas.select do |definition|
      definition.status == 'Exhausted'
    end
  end
  
  def apply_not_exhausted_filter(quotas)
    quotas.reject do |definition|
      definition.status == 'Exhausted'
    end
  end
  
  def apply_blocked_filter(quotas)
    quotas.select do |definition|
      definition.last_blocking_period.present?
    end
  end

  def apply_not_blocked_filter(quotas)
    quotas.reject do |definition|
      definition.last_blocking_period.present?
    end
  end
end