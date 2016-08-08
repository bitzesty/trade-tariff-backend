class MeasurePresenter
  THIRD_COUNTRY_DUTY_ID = '103'
  HIDDEN_MEASURE_TYPE_IDS = ['430', '447']

  def initialize(collection, declarable)
    @collection = collection
    @declarable = declarable
  end

  def validate!
    @collection = measure_deduplicate
  end

  private

  def measure_deduplicate
    if @collection.select{|m| m.measure_type_id == THIRD_COUNTRY_DUTY_ID}.size > 1
      @collection.delete_if { |m| m.measure_type_id == THIRD_COUNTRY_DUTY_ID &&
                                  m.additional_code.blank? &&
                                  m.goods_nomenclature_sid != @declarable.goods_nomenclature_sid }
    end

    if @collection.select{|m| m.measure_type_id == 'VTS'}.any?
      @collection.delete_if { |m| m.measure_type_id == 'VTS' &&
                                  m.goods_nomenclature_sid != @declarable.goods_nomenclature_sid }
    end

    if @collection.select{|m| m.measure_type_id == 'VTZ'}.any?
      @collection.delete_if { |m| m.measure_type_id == 'VTZ' &&
                                  m.goods_nomenclature_sid != @declarable.goods_nomenclature_sid }
    end

    @collection.delete_if do |m|
      HIDDEN_MEASURE_TYPE_IDS.include?(m.measure_type_id)
    end

    @collection
  end

  def method_missing(*args, &block)
    @collection.send(*args, &block)
  end
end
