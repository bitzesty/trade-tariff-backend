class MeasurePartialTemporaryStop < ActiveRecord::Base
  belongs_to :measure, foreign_key: :measure_sid
  # belongs_to :base_regulation, foreign_key: [:abrogation_regulation_id]
  # belongs_to :base_regulation, foreign_key: [:partial_temporary_stop_regulation_id]
end
