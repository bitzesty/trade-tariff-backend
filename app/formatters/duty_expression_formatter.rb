class DutyExpressionFormatter
  class << self
    def prettify(float)
      TradeTariffBackend.number_formatter.number_with_precision(
        float,
        minimum_decimal_points: 2,
        precision: 4,
        strip_insignificant_zeros: true
      )
    end

    def format(opts={})
      duty_expression_id = opts[:duty_expression_id]
      duty_expression_description = opts[:duty_expression_description]
      duty_expression_abbreviation = opts[:duty_expression_abbreviation]
      duty_amount = opts[:duty_amount]
      monetary_unit = opts[:monetary_unit_abbreviation].presence || opts[:monetary_unit]
      measurement_unit = opts[:measurement_unit]
      measurement_unit_qualifier = opts[:measurement_unit_qualifier]
      measurement_unit_abbreviation = measurement_unit.try :abbreviation,
                                                           measurement_unit_qualifier: measurement_unit_qualifier


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
      case duty_expression_id
      when "99"
        if opts[:formatted]
          output << "<abbr title='#{measurement_unit.description}'>#{measurement_unit_abbreviation}</abbr>"
        else
          output << "#{measurement_unit_abbreviation}"
        end
      when "12", "14", "37", "40", "41", "42", "43", "44", "21", "25", "27", "29"
        if duty_expression_abbreviation.present?
          output << duty_expression_abbreviation
        elsif duty_expression_description.present?
          output << duty_expression_description
        end
      when "02", "04", "15", "17", "19", "20", "36"
        if duty_expression_abbreviation.present?
          output << duty_expression_abbreviation
        elsif duty_expression_description.present?
          output << duty_expression_description
        end
        if duty_amount.present?
          if opts[:formatted]
            output << "<span title='#{eur_duty_amount} EUR'>#{prettify(duty_amount).to_s}</span>"
          else
            output << prettify(duty_amount).to_s
          end
        end
        if monetary_unit.present?
          output << monetary_unit
        else
          output << "%"
        end
        if measurement_unit_abbreviation.present?
          if opts[:formatted]
            output << "/ <abbr title='#{measurement_unit.description}'>#{measurement_unit_abbreviation}</abbr>"
          else
            output << "/ #{measurement_unit_abbreviation}"
          end
        end
      else
        if duty_amount.present?
          if opts[:formatted]
            output << "<span title='#{eur_duty_amount} EUR'>#{prettify(duty_amount).to_s}</span>"
          else
            output << prettify(duty_amount).to_s
          end
        end
        if duty_expression_abbreviation.present? && !monetary_unit.present?
          output << duty_expression_abbreviation
        elsif duty_expression_description.present? && !monetary_unit.present?
          output << duty_expression_description
        elsif duty_expression_description.blank?
          output << "%"
        end
        if monetary_unit.present?
          output << monetary_unit
        end
        if measurement_unit_abbreviation.present?
          if opts[:formatted]
            output << "/ <abbr title='#{measurement_unit.description}'>#{measurement_unit_abbreviation}</abbr>"
          else
            output << "/ #{measurement_unit_abbreviation}"
          end
        end
      end
      output.join(" ").html_safe
    end
  end
end
