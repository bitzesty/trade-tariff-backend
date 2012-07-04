class MeasurePartialTemporaryStop < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :measure, foreign_key: :measure_sid
  # TODO FIXME
  # belongs_to :base_regulation, foreign_key: [:abrogation_regulation_id]
  # belongs_to :base_regulation, foreign_key: [:partial_temporary_stop_regulation_id]
end
