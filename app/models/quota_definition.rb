class QuotaDefinition < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :quota_definition_sid
  plugin :conformance_validator

  set_primary_key [:quota_definition_sid]

  one_to_many :quota_exhaustion_events, key: :quota_definition_sid,
                                        primary_key: :quota_definition_sid

  one_to_many :quota_balance_events, key: :quota_definition_sid,
                                     primary_key: :quota_definition_sid
  one_to_many :quota_suspension_periods, key: :quota_definition_sid,
                                         primary_key: :quota_definition_sid
  one_to_many :quota_blocking_periods, key: :quota_definition_sid,
                                       primary_key: :quota_definition_sid

  one_to_one :measurement_unit, primary_key: :measurement_unit_code,
             key: :measurement_unit_code do |ds|
    ds.with_actual(MeasurementUnit)
  end

  delegate :description, :abbreviation, to: :measurement_unit, prefix: true, allow_nil: true

  def formatted_measurement_unit
    "#{measurement_unit_description} (#{measurement_unit_abbreviation})" if measurement_unit_description.present?
  end

  def status
    QuotaEvent.last_for(quota_definition_sid, point_in_time).status.presence || (critical_state? ? 'Critical' : 'Open')
  end

  def last_balance_event
    @_last_balance_event ||= quota_balance_events.select { |balance| balance.occurrence_timestamp <= point_in_time }.sort_by(&:occurrence_timestamp).last
  end

  def balance
    last_balance_event.present? ? last_balance_event.new_balance : volume
  end

  def last_suspension_period
    @_last_suspension_period ||= quota_suspension_periods.last
  end

  def last_blocking_period
    @_last_blocking_period ||= quota_blocking_periods.last
  end

private

  def critical_state?
    critical_state == 'Y'
  end
end
