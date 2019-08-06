class QuotaSearchService
  attr_accessor :scope, :result
  attr_reader :goods_nomenclature_item_id, :geographical_area_id, :order_number, :critical, :years, :status

  def initialize(attributes)
    self.scope = Measure.
      eager(quota_definition: [:measures, :quota_exhaustion_events, :quota_blocking_periods, quota_order_number: [quota_order_number_origins: :geographical_area]]).
      distinct(:measures__ordernumber, :measures__validity_start_date).
      select(Sequel.expr(:measures).*).
      exclude(measures__ordernumber: nil)

    @goods_nomenclature_item_id = attributes['goods_nomenclature_item_id']
    @geographical_area_id = attributes['geographical_area_id']
    @order_number = attributes['order_number']
    @critical = attributes['critical']
    @years = Array.wrap(attributes['year']).join(', ')
    @status = (attributes['status'] || '').downcase.tr(' ', '_')
  end

  def perform
    apply_goods_nomenclature_item_id_filter if goods_nomenclature_item_id.present?
    apply_geographical_area_id_filter if geographical_area_id.present?
    apply_order_number_filter if order_number.present?
    apply_critical_filter if critical.present?
    apply_years_filter if years.present?

    self.result = scope.all.map(&:quota_definition_or_nil)
    apply_status_filters if result.present? && status.present?
    result
  end

  private

  def apply_goods_nomenclature_item_id_filter
    self.scope = scope.where(Sequel.like(:measures__goods_nomenclature_item_id, "#{goods_nomenclature_item_id}%"))
  end

  def apply_geographical_area_id_filter
    self.scope = scope.where(measures__geographical_area_id: geographical_area_id)
  end

  def apply_order_number_filter
    self.scope = scope.where(Sequel.like(:measures__ordernumber, "#{order_number}%"))
  end

  def apply_critical_filter
    self.scope = scope.
      join(:quota_definitions, [[:measures__ordernumber, :quota_definitions__quota_order_number_id], [:measures__validity_start_date, :quota_definitions__validity_start_date]]).
      where(quota_definitions__critical_state: critical)
  end

  def apply_years_filter
    @scope = scope.where("EXTRACT(YEAR FROM measures.validity_start_date) IN (#{years})")
  end

  def apply_status_filters
    send("apply_#{status}_filter")
  end

  def apply_exhausted_filter
    self.result = result.select do |definition|
      definition.status == 'Exhausted'
    end
  end

  def apply_not_exhausted_filter
    self.result = result.reject do |definition|
      definition.status == 'Exhausted'
    end
  end

  def apply_blocked_filter
    self.result = result.select do |definition|
      definition.last_blocking_period.present?
    end
  end

  def apply_not_blocked_filter
    self.result = result.reject do |definition|
      definition.last_blocking_period.present?
    end
  end
end