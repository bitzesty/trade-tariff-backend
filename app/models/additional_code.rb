class AdditionalCode < Sequel::Model
  plugin :time_machine

  set_primary_key :additional_code_sid

  many_to_many :additional_code_descriptions, join_table: :additional_code_description_periods,
                                              left_key: :additional_code_sid,
                                              right_key: [:additional_code_description_period_sid,
                                                          :additional_code_sid] do |ds|
                                                ds.with_actual(AdditionalCodeDescriptionPeriod)
                                              end

  def additional_code_description
    additional_code_descriptions.first
  end

  one_to_one :meursing_additional_code, key: :additional_code,
                                        primary_key: :additional_code

  one_to_one :export_refund_nomenclature, key: :export_refund_code,
                                          primary_key: :additional_code

  delegate :description, to: :additional_code_description

  def exists_as_meursing_code?
    meursing_additional_code.present?
  end

  def does_not_exist_as_meursing_code?
    !exists_as_meursing_code?
  end

  def exists_as_export_refund_code?
    export_refund_nomenclature.present?
  end

  def code
    "#{additional_code_type_id}#{additional_code}"
  end

  ######### Conformance validations 245
  validates do
    # ACN1
    # TODO: ACN2
    uniqueness_of [:additional_code, :additional_code_type_id, :validity_start_date]
    # ACN3
    validity_dates
    # TODO: ACN4
    # TODO: ACN12
    # TODO: ACN13
    # TODO: ACN17
    # TODO: ACN6
    # TODO: ACN7
    # TODO: ACN8
    # TODO: ACN9
    # TODO: ACN10
    # TODO: ACN11
    # TODO: ACN16
    # TODO: ACN5
    # TODO: ACN14
    # TODO: ACN15
  end
end


