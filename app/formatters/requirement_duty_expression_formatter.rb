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

      if opts[:convert_currency].present?
        if monetary_unit == "EUR" && duty_amount.present?
          period = MonetaryExchangePeriod.actual.last(parent_monetary_unit_code: "EUR")
          gbp = MonetaryExchangeRate.last(monetary_exchange_period_sid: period.monetary_exchange_period_sid, child_monetary_unit_code: "GBP")
          eur_duty_amount = duty_amount
          duty_amount = (gbp.exchange_rate * duty_amount.to_d).to_f
          monetary_unit = "GBP"
        end
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
