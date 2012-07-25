class MeasureAction < Sequel::Model
  plugin :time_machine

  set_primary_key :action_code

  one_to_one :measure_action_description, key: :action_code,
                                          primary_key: :action_code

  delegate :description, to: :measure_action_description
end


