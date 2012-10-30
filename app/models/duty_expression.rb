class DutyExpression < Sequel::Model
  plugin :time_machine

  set_primary_key :duty_expression_id

  one_to_one :duty_expression_description

  delegate :abbreviation, :description, to: :duty_expression_description

  ######### Conformance validations 230
  validates do
    # DE1
    uniqueness_of :duty_expression_id
    # DE2
    validity_dates
    # TODO: DE3
    # TODO: DE4
  end
end


