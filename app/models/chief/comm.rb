module Chief
  class Comm < Sequel::Model
    set_dataset db[:chief_comm].
                order(:fe_tsmp.asc)

    set_primary_key [:fe_tsmp, :cmdty_code, :audit_tsmp]

    one_to_one :first_unit_of_quantity, class_name: 'Chief::Unoq',
                                        key: :tbl_code,
                                        primary_key: :uoq_code_cdu1
    one_to_one :second_unit_of_quantity, class_name: 'Chief::Unoq',
                                         key: :tbl_code,
                                         primary_key: :uoq_code_cdu2
    one_to_one :third_unit_of_quantity, class_name: 'Chief::Unoq',
                                        key: :tbl_code,
                                        primary_key: :uoq_code_cdu3

    dataset_module do
      def with_additional_national_quantities
        filter{~{uoq_code_cdu2: nil} | ~{uoq_code_cdu3: nil}}
      end

      def without_additional_national_quantities
        filter(uoq_code_cdu2: nil, uoq_code_cdu3: nil)
      end
    end
  end
end
