class QuotaSearchService

  attr_reader :scope, :as_of, :status
  
  def initialize(attributes)
    @scope = QuotaOrderNumber.
               eager(:quota_order_number_origin, quota_definition: [:quota_exhaustion_events, :quota_blocking_periods]).
               distinct(:quota_order_numbers__quota_order_number_sid).
               join(:quota_order_number_origins, quota_order_numbers__quota_order_number_sid: :quota_order_number_origins__quota_order_number_sid).
               join(:quota_definitions, quota_order_numbers__quota_order_number_id: :quota_definitions__quota_order_number_id)
    
    if attributes.present?
      attributes.each do |name, value|
        if self.respond_to?(:"#{name}=")
          send(:"#{name}=", value)
        end
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
    @scope = scope.where(quota_definitions__critical_state: value ? 'Y' : 'N')
  end
  
  def year=(value)
    @as_of = begin
               Date.new(value.to_i, 12, 31)
             rescue
               Date.current
             end
  end
  
  def status=(value)
    @status = value.downcase.tr(' ', '_')
  end
  
  def perform
    result = scope.
                actual.
                with_actual(QuotaOrderNumberOrigin, QuotaOrderNumber).
                with_actual(QuotaDefinition, QuotaOrderNumber).
                all
    
    apply_status_filters(result)
  end

  private
  
  def apply_status_filters(quotas)
    return quotas unless quotas.present? && status.present?
    send("apply_#{status}_filter", quotas)
  end
  
  def apply_exhausted_filter(quotas)
    quotas.select do |quota_order_number|
      quota_order_number.definition&.status == 'Exhausted'
    end
  end
  
  def apply_not_exhausted_filter(quotas)
    quotas.reject do |quota_order_number|
      quota_order_number.definition&.status == 'Exhausted'
    end
  end
  
  def apply_blocked_filter(quotas)
    quotas.select do |quota_order_number|
      quota_order_number.definition&.last_blocking_period.present?
    end
  end

  def apply_not_blocked_filter(quotas)
    quotas.reject do |quota_order_number|
      quota_order_number.definition&.last_blocking_period.present?
    end
  end
end