class Measurement < Sequel::Model
  set_primary_keys  :measurement_unit_code, :measurement_unit_qualifier_code

  # belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  # belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  # has_many :measure_components, foreign_key: [:measurement_unit_code, :measurement_unit_qualifier_code]
end

# == Schema Information
#
# Table name: measurements
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  measurement_unit_code           :string(255)
#  measurement_unit_qualifier_code :string(255)
#  validity_start_date             :date
#  validity_end_date               :date
#  created_at                      :datetime
#  updated_at                      :datetime
#

