class DutyExpression < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :measures
  has_many :measure_components
  has_many :measure_condition_components
end
