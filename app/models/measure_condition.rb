class MeasureCondition < Sequel::Model
  plugin :time_machine

  set_primary_key :measure_condition_sid

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  one_to_one :measure_action, dataset: -> {
    actual(MeasureAction)
                 .where(action_code: action_code)
  }
  one_to_one :certificate, dataset: -> {
    actual(Certificate).where(certificate_code: certificate_code,
                      certificate_type_code: certificate_type_code)
  }

  one_to_one :measure_condition_code, key: [:condition_code],
                                      primary_key: [:condition_code]

  def document_code
    "#{certificate_type_code}#{certificate_code}"
  end
  # belongs_to :measure, foreign_key: :measure_sid
  # belongs_to :measure_action, foreign_key: :action_code
  # belongs_to :monetary_unit, foreign_key: :condition_monetary_unit_code
  # belongs_to :measurement_unit, foreign_key: :condition_measurement_unit_code
  # belongs_to :measurement_unit_qualifier, foreign_key: :condition_measurement_unit_qualifier_code
  # belongs_to :measure_action, foreign_key: :action_code
  # belongs_to :certificate, foreign_key: [:certificate_code, :certificate_type_code]
  # belongs_to :certificate_type, foreign_key: :certificate_type_code
  # belongs_to :measure_condition_code, foreign_key: :condition_code
end


