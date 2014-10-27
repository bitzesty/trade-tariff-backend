module Chief
  class Tamf < Sequel::Model
    set_dataset db[:chief_tamf].
                order(Sequel.asc(:msrgp_code)).
                order_more(Sequel.asc(:msr_type)).
                order_more(Sequel.asc(:tty_code)).
                order_more(Sequel.asc(:fe_tsmp))

    set_primary_key [:msrgp_code,
                     :msr_type,
                     :tty_code,
                     :tar_msr_no,
                     :cngp_code,
                     :cntry_disp,
                     :cntry_orig,
                     :fe_tsmp,
                     :amend_indicator]

    one_to_many :measure_type_conds, key: [:measure_group_code, :measure_type],
                                     primary_key: [:msrgp_code, :msr_type],
                                     class_name: 'Chief::MeasureTypeCond'


    one_to_one :measure_type_adco, key: [:measure_group_code, :measure_type, :tax_type_code],
                                   primary_key: [:msrgp_code, :msr_type, :tty_code],
                                   class_name: 'Chief::MeasureTypeAdco'

    one_to_one :duty_expression, key: [:adval1_rate, :adval2_rate, :spfc1_rate, :spfc2_rate],
                                 primary_key: [:adval1_rate_key, :adval2_rate_key, :spfc1_rate_key, :spfc2_rate_key],
                                 class_name: 'Chief::DutyExpression'

    def adval1_rate_key; adval1_rate.present?; end
    def adval2_rate_key; adval2_rate.present?; end
    def spfc1_rate_key; spfc1_rate.present?; end
    def spfc2_rate_key; spfc2_rate.present?; end

    dataset_module do
      def unprocessed
        filter(processed: false)
      end
    end

    def mark_as_processed!
      self.this.unlimited.update(processed: true)
    end

    def measurement_unit(cmpd_uoq, uoq)
      Chief::MeasurementUnit.where(spfc_cmpd_uoq: cmpd_uoq,
                                   spfc_uoq: uoq).first
    end

    def geographical_area
      chief_geographical_area = cngp_code.presence || cntry_orig.presence || cntry_disp.presence
    end

    def measure_components
      if duty_expression(true).present?
        duty_expression_components
      else
        duty_type_components
      end
    end

    # From CHIEF manual:
    #
    # DUTY-TYPE: Identifies the type of calculation used to arrive
    # at the duty for a Tariff measure. The duty type also determines
    # the number and type of duty rate components.
    #
    # More info https://www.pivotaltracker.com/story/show/59551288
    def duty_type_components
      if duty_type == '30' && tty_code.to_s.in?(['570', '551'])
        [
          MeasureComponent.new do |mc|
            mc.duty_amount = 0.0
            mc.duty_expression_id = '01'
            mc.monetary_unit_code = 'GBP'
            mc.measurement_unit_code = 'LTR'
          end
        ]
      else
        []
      end
    end

    def duty_expression_components
      components = []

      if duty_expression.duty_expression_id_spfc1.present?
        measure_component = MeasureComponent.new do |mc|
          mc.duty_amount = spfc1_rate
          mc.duty_expression_id = duty_expression.duty_expression_id_spfc1
          mc.monetary_unit_code = duty_expression.monetary_unit_code_spfc1
        end
        if measure_component.monetary_unit_code.present?
          if m_unit = measurement_unit(spfc1_cmpd_uoq, spfc1_uoq)
            measure_component.measurement_unit_code = m_unit.measurem_unit_cd
            measure_component.measurement_unit_qualifier_code = m_unit.measurem_unit_qual_cd
          end
        end

        components << measure_component
      end

      if duty_expression.duty_expression_id_spfc2.present?
        measure_component = MeasureComponent.new do |mc|
          mc.duty_amount = spfc2_rate
          mc.duty_expression_id = duty_expression.duty_expression_id_spfc2
          mc.monetary_unit_code = duty_expression.monetary_unit_code_spfc2
        end
        if measure_component.monetary_unit_code.present?
          if m_unit = measurement_unit(spfc1_cmpd_uoq, spfc2_uoq)
            measure_component.measurement_unit_code = m_unit.measurem_unit_cd
            measure_component.measurement_unit_qualifier_code = m_unit.measurem_unit_qual_cd
          end
        end

        components << measure_component
      end

      if duty_expression.duty_expression_id_adval1.present?
        measure_component = MeasureComponent.new do |mc|
          mc.duty_amount = adval1_rate
          mc.duty_expression_id = duty_expression.duty_expression_id_adval1
        end

        components << measure_component
      end

      if duty_expression.duty_expression_id_adval2.present?
        measure_component = MeasureComponent.new do |mc|
          mc.duty_amount = adval2_rate
          mc.duty_expression_id = duty_expression.duty_expression_id_adval2
        end

        components << measure_component
      end

      components
    end
  end
end
