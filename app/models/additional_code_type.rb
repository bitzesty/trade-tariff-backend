class AdditionalCodeType < Sequel::Model
  set_primary_key :additional_code_type_id

  one_to_many :additional_codes, key: :additional_code_type_id
  one_to_one  :additional_code_type_description, key: :additional_code_type_id
  one_to_many :additional_code_descriptions, key: :additional_code_type_id
  one_to_many :additional_code_type_measure_types
  many_to_many :measure_types, join_table: :additional_code_type_measure_types
  one_to_many :additional_code_description_periods, key: :additional_code_type_id
  one_to_many :footnote_association_additional_codes, key: :additional_code_type_id
  many_to_many :footnotes, join_table: :footnote_association_additional_codes,
                           class_name: 'Footnote'
  one_to_many :export_refund_nomenclatures, primary_key: :additional_code_type_id,
                                            key: :additional_code_type

  many_to_one :meursing_table_plan

  delegate :present?, to: :meursing_table_plan, prefix: true, allow_nil: true

  APPLICATION_CODES = {
    0 => "Export refund nomencalture",
    1 => "Additional Codes",
    3 => "Meursing addition codes",
    4 => "Export refund for processed agricultural goods"
  }

  ######### Conformance validations 120
  validates do
    # CT1
    uniqueness_of :additional_code_type_id
    # CT2
    input_of :meursing_table_plan_id, if: :meursing?
    # CT3
    associated :meursing_table_plan, ensure: :meursing_table_plan_present?,
                                     if: :should_validate_meursing_table_plan?
    # CT4
    validity_dates
  end

  def before_destroy
    # CT6
    return false if additional_codes.select{|adco| adco.meursing_additional_code.blank? }.any?
    # CT7
    return false if meursing_table_plan_id.present?
    # CT9
    return false if export_refund? && export_refund_nomenclatures.any?
    # CT10
    return false if measure_types.any?
    # CT11
    return false if

    super
  end

  def should_validate_meursing_table_plan?
    meursing_table_plan_id.present? && meursing?
  end

  def related_to_measure_type?
    measure_types.any?
  end

  def meursing?
    application_code == "3"
  end

  def non_meursing?
    !meursing?
  end

  def export_refund?
    application_code == "0"
  end

  def export_refund_agricultural?
    application_code == "4"
  end
end


