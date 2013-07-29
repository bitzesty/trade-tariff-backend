module Chief
  class Tame < Sequel::Model
    set_dataset db[:chief_tame].
                order(Sequel.asc(:audit_tsmp), Sequel.asc(:fe_tsmp))

    set_primary_key [:msrgp_code,
                     :msr_type,
                     :tty_code,
                     :tar_msr_no,
                     :fe_tsmp,
                     :le_tsmp,
                     :audit_tsmp,
                     :amend_indicator]

    one_to_one :measure_type, key: {}, primary_key: {},
      dataset: -> { Chief::MeasureTypeAdco.where(chief_measure_type_adco__measure_group_code: msrgp_code,
                                                 chief_measure_type_adco__measure_type: msr_type,
                                                 chief_measure_type_adco__tax_type_code: tty_code) },
                                                 class_name: 'Chief::MeasureTypeAdco'

    one_to_one :duty_expression, key: [:adval1_rate, :adval2_rate, :spfc1_rate, :spfc2_rate],
                                 primary_key: [:adval1_rate, :adval2_rate, :spfc1_rate, :spfc2_rate]

    one_to_many :tamfs, key:{}, primary_key: {}, dataset: -> {
      Chief::Tamf.filter({:fe_tsmp => fe_tsmp})
                 .filter({:msrgp_code => msrgp_code})
                 .filter({:msr_type => msr_type})
                 .filter({:tty_code => tty_code})
                 .filter({:tar_msr_no => tar_msr_no})
                 .filter({:amend_indicator => amend_indicator})
    }, class_name: 'Chief::Tamf'

    one_to_many :mfcms, key: {}, primary_key: {}, dataset: -> {
      Chief::Mfcm.filter({:msrgp_code => msrgp_code})
                 .filter({:msr_type => msr_type})
                 .filter({:tty_code => tty_code})
                 .filter({:tar_msr_no => tar_msr_no})
                 .order(Sequel.asc(:audit_tsmp))
    }

    one_to_one :chief_update, key: :filename,
                              primary_key: :origin,
                              class_name: TariffSynchronizer::ChiefUpdate

    delegate :issue_date, to: :chief_update, allow_nil: true

    dataset_module do
      def unprocessed
        filter(processed: false)
      end
    end

    def adval1_rate; 1; end
    def adval2_rate; 0; end
    def spfc1_rate; 0; end
    def spfc2_rate; 0; end

    def mark_as_processed!
      self.this.unlimited.update(processed: true)

      tamfs.each(&:mark_as_processed!)
    end

    def has_tamfs?
      tamfs.any?
    end

    def audit_tsmp
      self[:audit_tsmp].presence || Time.now
    end

    def operation_date
      issue_date
    end
  end
end


