class MeasurePresenter
  THIRD_COUNTRY_DUTY_ID = '103'

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
                                  m.goods_nomenclature_sid != @declarable.goods_nomenclature_sid }
    else
      @collection
    end
  end

  def method_missing(*args, &block)
    @collection.send(*args, &block)
  end
end
