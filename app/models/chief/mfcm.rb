require 'null_object'

module Chief
  class Mfcm < Sequel::Model
    set_dataset db[:chief_mfcm].
                order(:msrgp_code.asc).
                order_more(:msr_type.asc).
                order_more(:tty_code.asc).
                order_more(:fe_tsmp.desc)

    set_primary_key [:msrgp_code, :msr_type, :tty_code, :cmdty_code, :fe_tsmp]

    one_to_one :tame, key: {}, primary_key: {}, dataset: -> {
      Chief::Tame.filter{ |o| o.<=(:fe_tsmp, fe_tsmp) &
                              {:msrgp_code => msrgp_code} &
                              {:msr_type => msr_type} &
                              {:tty_code => tty_code}
                              }.order(:fe_tsmp.desc)
    }, class_name: 'Chief::Tame'

    one_to_many :tamfs, key: {}, primary_key: {}, dataset: -> {
      Chief::Tamf.filter{ |o| {:msrgp_code => msrgp_code} &
                              {:msr_type => msr_type} &
                              {:tty_code => tty_code}
                              }.order(:fe_tsmp.desc)
    }

    one_to_one :measure_type_adco, key: {}, primary_key: {},
      dataset: -> { Chief::MeasureTypeAdco.where(chief_measure_type_adco__measure_group_code: msrgp_code,
                                                 chief_measure_type_adco__measure_type: msr_type,
                                                 chief_measure_type_adco__tax_type_code: tty_code) }

    one_to_one :measure_type, key: {}, primary_key: {},
      dataset: -> { Chief::MeasureTypeAdco.where(chief_measure_type_adco__measure_group_code: msrgp_code,
                                                 chief_measure_type_adco__measure_type: msr_type,
                                                 chief_measure_type_adco__tax_type_code: tty_code) },
                                                 class_name: 'Chief::MeasureTypeAdco'

    dataset_module do
      def untransformed
        filter(transformed: false)
      end

      def valid_to(timestamp)
        where("fe_tsmp < ?", timestamp)
      end

      def valid_to_inclusive(timestamp)
        where("fe_tsmp <= ?", timestamp)
      end
    end

    def validate
      super

      errors.add(:name, 'cannot be seasonal commodity code') if cmdty_code.match(/\D/)
      errors.add(:name, 'cannot be pseudo commodity code') if cmdty_code.first(2) == "99"
    end

    def measure_type_adco
      _measure_type_adco_dataset.first.presence || ::NullObject.new
    end

    def audit_tsmp
      self[:audit_tsmp].presence || Time.now
    end
  end
end
