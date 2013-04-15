######### Conformance validations 120
class AdditionalCodeTypeValidator < TradeTariffBackend::Validator
  validation :CT1, 'The additional code type must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:additional_code_type_id]
  end

  validation :CT2, 'The Meursing table plan can only be entered if the additional code type has as application code "Meursing table additional code type"', on: [:create, :update] do |record|
    if record.meursing_table_plan_id.present?
      record.meursing?
    end
  end

  validation :CT3, 'The Meursing Table plan must exist', on: [:create, :update] do |record|
    if record.meursing_table_plan_id.present?
      record.meursing_table_plan.present?
    end
  end

  validation :CT4, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end

  validation :CT6, 'The additional code type cannot be deleted if it is related with a non-Meursing additional code.', on: [:destroy] do |record|
    record.additional_codes.select{|adco| adco.meursing_additional_code.blank? }.none?
  end

  validation :CT7, 'The additional code type cannot be deleted if it is related with a Meursing Table plan.', on: [:destroy] do |record|
    record.meursing_table_plan_id.blank?
  end

  validation :CT9, 'The additional code type cannot be deleted if it is related with an Export refund code.', on: [:destroy] do |record|
    !record.export_refund? || (record.export_refund_nomenclatures.none?)
  end

  validation :CT10, 'The additional code type cannot be deleted if it is related with a measure type.', on: [:destroy] do |record|
    record.measure_types.none?
  end
end
