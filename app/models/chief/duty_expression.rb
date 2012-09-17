module Chief
  class DutyExpression < Sequel::Model
    set_dataset db[:chief_duty_expression]

    one_to_one :monetary_unit
  end
end
