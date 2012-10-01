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

  delegate :description, to: :measure_type_description

  ######### Conformance validations 235
  def validate
    super
    # MT1
    validates_unique(:measure_type_id)
    # MT2
    validates_start_date
    # TODO: MT3
    # MT4
    validates_presence :measure_type_series_id
    # TODO: MT7
    # TODO: MT10
  end

end


