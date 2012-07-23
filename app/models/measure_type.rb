class MeasureType < Sequel::Model
  IMPORT_MOVEMENT_CODES = [0, 2]
  EXPORT_MOVEMENT_CODES = [1, 2]

  plugin :time_machine

  set_primary_key :measure_type_id

  one_to_one :measure_type_description, key: :measure_type_id,
                                        foreign_key: :measure_type_id
  # has_one  :measure_type_description, foreign_key: :measure_type_id
  # has_many :measures, foreign_key: :measure_type
  # has_many :additional_code_type_measure_types, foreign_key: :measure_type_id
  # has_many :additional_code_types, through: :additional_code_type_measure_types
  # has_many :regulation_replacements, foreign_key: :measure_type_id

  # belongs_to :measure_type_series

  # delegate :description, to: :measure_type_description
end


