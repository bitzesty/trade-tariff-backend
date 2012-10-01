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

  many_to_one :meursing_table_plan

  APPLICATION_CODES = {
    0 => "Export refund nomencalture",
    1 => "Additional Codes",
    3 => "Meursing addition codes",
    4 => "Export refund for processed agricultural goods"
  }

  ######### Conformance validations 120
  def validate
    super
    # CT1
    validates_unique :additional_code_type_id
    # CT2
    if application_code != 3 && meursing_table_plan_id.present?
      errors.add(:meursing_table_plan_id,
        "The Meursing table plan can only be entered if the additional code type has as application code 'Meursing table additional code type'.")
    end
    # CT3
    validates_presence :meursing_table_plan_id if application_code == 3
    # CT4
    validates_start_date

    # TODO: CT6
    # TODO: CT7

    # TODO: CT9
    # TODO: CT10
    # TODO: CT11
  end


end


