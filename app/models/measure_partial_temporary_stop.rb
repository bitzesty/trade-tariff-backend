class MeasurePartialTemporaryStop < Sequel::Model
  set_primary_key  :measure_sid, :partial_temporary_stop_regulation_id

  # belongs_to :measure, foreign_key: :measure_sid
  # belongs_to :abrogated_regulation, primary_key: :base_regulation_id,
  #                                   foreign_key: :abrogation_regulation_id,
  #                                   class_name: 'BaseRegulation'
  # belongs_to :stopped_regulation, primary_key: :base_regulation_id,
  #                                 foreign_key: :partial_temporary_stop_regulation_id,
  #                                 class_name: 'BaseRegulation'
end


