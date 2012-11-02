class MeasureType < Sequel::Model
  IMPORT_MOVEMENT_CODES = [0, 2]
  EXPORT_MOVEMENT_CODES = [1, 2]
  EXCLUDED_TYPES = ['442', 'SPL']
  THIRD_COUNTRY = 103

  plugin :time_machine, period_start_column: :measure_types__validity_start_date,
                        period_end_column:   :measure_types__validity_end_date


  set_primary_key :measure_type_id

  one_to_one :measure_type_description, key: :measure_type_id,
                                        foreign_key: :measure_type_id

  one_to_many :measures, key: :measure_type,
                         foreign_key: :measure_type_id

  many_to_one :measure_type_series

  delegate :description, to: :measure_type_description

  dataset_module do
    def national
      where(national: true)
    end
  end

  ######### Conformance validations 235
  validates do
    # MT1
    uniqueness_of :measure_type_id
    # MT2
    validity_dates
    # TODO: MT3
    # MT4
    presence_of :measure_type_series, if: :has_measure_type_series_reference?
    # TODO: MT7
    # TODO: MT10
  end

  def order_number_capture_code_permitted?
    order_number_capture_code == "1"
  end

  def has_measure_type_series_reference?
    measure_type_series_id.present?
  end
end


