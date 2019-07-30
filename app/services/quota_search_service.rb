class QuotaSearchService
  attr_reader :scope, :status

  def initialize(attributes)
    @scope = Measure.
      eager(quota_definition: [:measures, :quota_exhaustion_events, :quota_blocking_periods, quota_order_number: [quota_order_number_origins: :geographical_area]]).
      distinct(:measures__ordernumber, :measures__validity_start_date).
      select(Sequel.expr(:measures).*).
      exclude(measures__ordernumber: nil)

    if attributes.present?
      attributes.each do |name, value|
        send(:"#{name}=", value) if self.respond_to?(:"#{name}=") && value.present?
      end
    end
  end

  def goods_nomenclature_item_id=(value)
    @scope = scope.where(Sequel.like(:measures__goods_nomenclature_item_id, "#{value}%"))
  end

  def geographical_area_id=(value)
    @scope = scope.where(measures__geographical_area_id: value)
  end

  def order_number=(value)
    @scope = scope.where(Sequel.like(:measures__ordernumber, "#{value}%"))
  end

  def critical=(value)
    @scope = scope.
      join(:quota_definitions, [[:measures__ordernumber, :quota_definitions__quota_order_number_id], [:measures__validity_start_date, :quota_definitions__validity_start_date]]).
      where(quota_definitions__critical_state: value)
  end

  def year=(value)
    @scope = scope.where("EXTRACT(YEAR FROM measures.validity_start_date) IN (#{Array.wrap(value).join(', ')})")
  end

  def status=(value)
    @status = value.downcase.tr(' ', '_')
  end

  def perform
    result = scope.all.map(&:quota_definition_or_nil)
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