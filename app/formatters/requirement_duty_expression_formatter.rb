class RequirementDutyExpressionFormatter
  class << self
    def prettify(float)
      TradeTariffBackend.number_formatter.number_with_precision(
        float,
        precision: 4,
        minimum_decimal_points: 2,
        strip_insignificant_zeros: true
      )
    end

    def format(opts={})
      duty_amount = opts[:duty_amount]
      monetary_unit = opts[:monetary_unit_abbreviation].presence || opts[:monetary_unit]
      measurement_unit = opts[:measurement_unit]
      measurement_unit_qualifier = opts[:formatted_measurement_unit_qualifier]

      if duty_amount.present? && opts[:currency].present? && monetary_unit.present? && monetary_unit != opts[:currency]
        period = MonetaryExchangePeriod.actual.last(parent_monetary_unit_code: 'EUR')
        rate = MonetaryExchangeRate.last(monetary_exchange_period_sid: period.monetary_exchange_period_sid, child_monetary_unit_code: monetary_unit == 'EUR' ? opts[:currency] : monetary_unit)
        duty_amount = monetary_unit == 'EUR' ? (rate.exchange_rate * duty_amount.to_d).to_f : (duty_amount.to_d / rate.exchange_rate).to_f
        monetary_unit = opts[:currency]
      end

      output = []

      if duty_amount.present?
        output << prettify(duty_amount).to_s
      end

      if monetary_unit.present? && measurement_unit.present? && measurement_unit_qualifier.present?
        output << "#{monetary_unit}/(#{measurement_unit}/#{measurement_unit_qualifier})"
      elsif monetary_unit.present? && measurement_unit.present?
        output << "#{monetary_unit}/#{measurement_unit}"
      elsif measurement_unit.present?
        output << measurement_unit
      end
      output.join(" ").html_safe
    end
  end
end
