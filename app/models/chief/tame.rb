module Chief
  class Tame < Sequel::Model
    set_dataset db[:chief_tame].
                order(:msrgp_code.asc).
                order_more(:msr_type.asc).
                order_more(:tty_code.asc).
                order_more(:fe_tsmp.desc)

    set_primary_key [:msrgp_code, :msr_type, :tty_code, :fe_tsmp]

    one_to_one :measure_type_adco, key: [:measure_group_code, :measure_type, :tax_type_code],
                                   primary_key: [:msrgp_code, :msr_type, :tty_code]

    one_to_one :duty_expression, key: [:adval1_rate, :adval2_rate, :spfc1_rate, :spfc2_rate],
                                 primary_key: [:adval1_rate, :adval2_rate, :spfc1_rate, :spfc2_rate]

    one_to_many :tamfs, key:{}, primary_key: {}, dataset: -> {
      Chief::Tamf.filter{ |o| {:fe_tsmp => fe_tsmp} &
                              {:msrgp_code => msrgp_code} &
                              {:msr_type => msr_type} &
                              {:tty_code => tty_code} &
                              {:tar_msr_no => tar_msr_no}
                              }
    }, class_name: 'Chief::Tamf'

    one_to_many :mfcms, key: {}, primary_key: {}, dataset: -> {
      Chief::Mfcm.filter{ |o| o.>=(:fe_tsmp, fe_tsmp) &
                              ((o.<=(:le_tsmp, le_tsmp)) | ({le_tsmp: nil})) &
                              {:msrgp_code => msrgp_code} &
                              {:msr_type => msr_type} &
                              {:tty_code => tty_code}
                        }
    }

    dataset_module do
      def untransformed
        filter(transformed: false)
      end
    end

    def adval1_rate; 1; end
    def adval2_rate; 0; end
    def spfc1_rate; 0; end
    def spfc2_rate; 0; end
  end
end


