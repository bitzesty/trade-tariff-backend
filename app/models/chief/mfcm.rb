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
      Chief::Tame.filter{ |o| {:msrgp_code => msrgp_code} &
                              {:msr_type => msr_type} &
                              {:tty_code => tty_code} &
                              {:tar_msr_no => tar_msr_no}
                              }.untransformed
    }, class_name: 'Chief::Tame'

    one_to_one :measure_type_adco, key: [:measure_group_code, :measure_type, :tax_type_code],
                                   primary_key: [:msrgp_code, :msr_type, :tty_code]

    dataset_module do
      def untransformed
        filter(transformed: false)
      end
    end

    def validate
      super

      errors.add(:name, 'cannot be seasonal commodity code') if cmdty_code.match(/\D/)
      errors.add(:name, 'cannot be pseudo commodity code') if cmdty_code.first(2) == "99"
    end

    def measure_type_adco
      self[:measure_type_adco].presence || ::NullObject.new
    end
  end
end
