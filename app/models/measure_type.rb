# National Measure Type ID mapping
# A B C D E F G H I J
# 1 2 3 4 5 6 7 8 9 0

class MeasureType < Sequel::Model
  IMPORT_MOVEMENT_CODES = [0, 2].freeze
  EXPORT_MOVEMENT_CODES = [1, 2].freeze
  EXCLUDED_TYPES = %w[442 SPL].freeze
  THIRD_COUNTRY = '103'.freeze
  VAT_TYPES = %w[VTA VTE VTS VTZ 305].freeze
  SUPPLEMENTARY_TYPES = %w[109 110 111].freeze

  plugin :time_machine, period_start_column: :measure_types__validity_start_date,
                        period_end_column:   :measure_types__validity_end_date
  plugin :oplog, primary_key: :measure_type_id
  plugin :conformance_validator

  set_primary_key [:measure_type_id]

  one_to_one :measure_type_description, key: :measure_type_id,
                                        foreign_key: :measure_type_id

  one_to_many :measures, key: :measure_type_id,
                         foreign_key: :measure_type_id

  many_to_one :measure_type_series

  delegate :description, to: :measure_type_description

  dataset_module do
    def national
      where(national: true)
    end
  end

  def id
    measure_type_id
  end

  def third_country?
    measure_type_id == THIRD_COUNTRY
  end

  # 306
  def excise?
    measure_type_series_id == 'Q'
  end

  # The VAT standard rate has measure type 305 and no additional code.
  # The VAT zero rate has measure type 305 and  VATZ additional code.
  # The VAT exempt has measure type 305 and  VATE additional code.
  # The VAT reduced rate 5% has measure type 305 and  VATA additional code.
  def vat?
    MeasureType::VAT_TYPES.include?(measure_type_id)
  end
end
