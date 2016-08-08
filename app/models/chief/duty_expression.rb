module Chief
  class DutyExpression < Sequel::Model(:chief_duty_expression)

    one_to_one :monetary_unit
  end
end
