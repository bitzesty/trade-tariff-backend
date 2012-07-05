class MonetaryUnit < ActiveRecord::Base
  set_primary_keys :monetary_unit_code

  has_many :measure_condition_components, foreign_key: :monetary_unit_code
  has_many :monetary_exchange_periods, foreign_key: :parent_monetary_unit_code
  has_many :monetary_exchange_rates, foreign_key: :child_monetary_unit_code
  has_many :quota_definitions, foreign_key: :monetary_unit_code
  has_many :measure_components, foreign_key: :monetary_unit_code
  has_many :measure_conditions, foreign_key: :monetary_unit_code
  has_many :measure_condition_components, foreign_key: :monetary_unit_code
  has_one  :monetary_unit_description, foreign_key: :monetary_unit_code
end

# == Schema Information
#
# Table name: monetary_units
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  monetary_unit_code     :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

