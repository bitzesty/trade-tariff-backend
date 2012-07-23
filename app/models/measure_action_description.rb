class MeasureActionDescription < Sequel::Model
  set_primary_key :action_code

  # belongs_to :measure_action, foreign_key: :action_code
  # belongs_to :language
end


