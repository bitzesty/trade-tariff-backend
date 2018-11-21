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
      measurement_unit_abbreviation = measurement_unit.try :abbreviation,
                                                           measurement_unit_qualifier: measurement_unit_qualifier
      currency = opts[:currency] || TradeTariffBackend.currency

      old_duty_amount = duty_amount
      old_monetary_unit = monetary_unit
      if duty_amount.present? && currency.present? && monetary_unit.present? && monetary_unit != currency
        period = MonetaryExchangePeriod.actual.last(parent_monetary_unit_code: 'EUR')
        if period.present?
          rate = MonetaryExchangeRate.last(monetary_exchange_period_sid: period.monetary_exchange_period_sid, child_monetary_unit_code: monetary_unit == 'EUR' ? currency : monetary_unit)
          if rate.present?
            duty_amount = (monetary_unit == 'EUR' ? (rate.exchange_rate * duty_amount.to_d).to_f : (duty_amount.to_d / rate.exchange_rate).to_f).round(2)
            monetary_unit = currency
          end
        end
      end

      output = []

      if duty_amount.present?
        if opts[:formatted]
          output << "<span title='#{old_duty_amount} #{old_monetary_unit}'>#{prettify(duty_amount).to_s}</span>"
        else
          output << prettify(duty_amount).to_s
        end
      end

      if monetary_unit.present? && measurement_unit_abbreviation.present? && measurement_unit_qualifier.present?
        if opts[:formatted]
          output << "#{monetary_unit} / (<abbr title='#{measurement_unit.description}'>#{measurement_unit_abbreviation}</abbr> / #{measurement_unit_qualifier})"
        else
          output << "#{monetary_unit} / (#{measurement_unit} / #{measurement_unit_qualifier})"
        end
      elsif monetary_unit.present? && measurement_unit_abbreviation.present?
        if opts[:formatted]
          output << "#{monetary_unit} / <abbr title='#{measurement_unit.description}'>#{measurement_unit_abbreviation}</abbr>"
        else
          output << "#{monetary_unit} / #{measurement_unit}"
        end
      elsif measurement_unit_abbreviation.present?
        if opts[:formatted]
          output << "<abbr title='#{measurement_unit.description}'>#{measurement_unit_abbreviation}</abbr>"
        else
          output << measurement_unit
        end
      end
      output.join(" ").html_safe
    end
  end
end
