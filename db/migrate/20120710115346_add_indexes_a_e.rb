class AddIndexesAE < ActiveRecord::Migration
  def up
    # AdditionalCode
    add_index :additional_codes, :additional_code_sid, unique: true, name: :primary_key
    add_index :additional_codes, :additional_code_type_id, name: :type_id

    # AdditionalCodeDescription
    add_index :additional_code_descriptions, [:additional_code_description_period_sid,
                                              :additional_code_sid], unique: true, name: :primary_key
    add_index :additional_code_descriptions, :additional_code_description_period_sid, name: :period_sid
    add_index :additional_code_descriptions, :language_id, name: :language_id
    add_index :additional_code_descriptions, :additional_code_type_id, name: :type_id
    add_index :additional_code_descriptions, :additional_code_sid, name: :sid

    # AdditionalCodeDescriptionPeriod
    add_index :additional_code_description_periods, [:additional_code_description_period_sid,
                                                     :additional_code_sid, :additional_code_type_id], unique: true,
                                                     name: :primary_key
    add_index :additional_code_description_periods, :additional_code_description_period_sid,
                                                    name: :description_period_sid
    add_index :additional_code_description_periods, :additional_code_type_id,
                                                    name: :code_type_id

    # AdditionalCodeType
    add_index :additional_code_types, :additional_code_type_id, unique: true, name: :primary_key
    add_index :additional_code_types, :meursing_table_plan_id

    # AdditionalCodeTypeDescription
    add_index :additional_code_type_descriptions, :additional_code_type_id, unique: true, name: :primary_key
    add_index :additional_code_type_descriptions, :language_id

    # AdditionalCodeTypeDescription
    add_index :additional_code_type_measure_types, [:measure_type_id, :additional_code_type_id], unique: true,
                                                                                                 name: :primary_key
    # BaseRegulation
    add_index :base_regulations, [:base_regulation_id, :base_regulation_role], unique: true, name: :primary_key
    add_index :base_regulations, :regulation_group_id
    add_index :base_regulations, [:explicit_abrogation_regulation_role, :explicit_abrogation_regulation_id],
                                 name: :explicit_abrogation_regulation
    add_index :base_regulations, [:complete_abrogation_regulation_role, :complete_abrogation_regulation_id],
                                 name: :complete_abrogation_regulation
    add_index :base_regulations, [:antidumping_regulation_role, :related_antidumping_regulation_id],
                                 name: :antidumping_regulation

    # Certificate
    add_index :certificates, [:certificate_code, :certificate_type_code], unique: true,
                                                                          name: :primary_key
    # CertificateDescription
    add_index :certificate_descriptions, :certificate_description_period_sid, unique: true,
                                                                              name: :primary_key
    add_index :certificate_descriptions, [:certificate_code, :certificate_type_code],
                                         name: :certificate
    add_index :certificate_descriptions, :language_id

    # CertificateDescriptionPeriod
    add_index :certificate_description_periods, :certificate_description_period_sid, unique: true,
                                                                              name: :primary_key
    add_index :certificate_description_periods, [:certificate_code, :certificate_type_code],
                                         name: :certificate

    # CertificateType
    add_index :certificate_types, :certificate_type_code, unique: true,
                                                          name: :primary_key

    # CertificateTypeDescription
    add_index :certificate_type_descriptions, :certificate_type_code, unique: true,
                                                                      name: :primary_key
    add_index :certificate_type_descriptions, :language_id

    # CompleteAbrogationRegulation
    add_index :complete_abrogation_regulations, [:complete_abrogation_regulation_id,
                                                 :complete_abrogation_regulation_role], unique: true,
                                                                                        name: :primary_key

    # DutyExpression
    add_index :duty_expressions, :duty_expression_id, unique: true, name: :primary_key

    # DutyExpressionDescription
    add_index :duty_expression_descriptions, :duty_expression_id, unique: true, name: :primary_key
    add_index :duty_expression_descriptions, :language_id

    # ExplicitAbrogationRegulation
    add_index :explicit_abrogation_regulations, [:explicit_abrogation_regulation_id,
                                                 :explicit_abrogation_regulation_role], unique: true,
                                                                                        name: :primary_key

    # ExportRefundNomenclature
    add_index :export_refund_nomenclatures, :export_refund_nomenclature_sid, unique: true, name: :primary_key
    add_index :export_refund_nomenclatures, :goods_nomenclature_sid

    # ExportRefundNomenclatureDescription
    add_index :export_refund_nomenclature_descriptions, [:export_refund_nomenclature_description_period_sid], unique: true, name: :primary_key
    add_index :export_refund_nomenclature_descriptions, :export_refund_nomenclature_sid,
                                                        name: :export_refund_nomenclature
    add_index :export_refund_nomenclature_descriptions, :language_id

    # ExportRefundNomenclatureDescriptionPeriod
    add_index :export_refund_nomenclature_description_periods, [:export_refund_nomenclature_sid, :export_refund_nomenclature_description_period_sid], unique: true, name: :primary_key

    # ExportRefundNomenclatureIndent
    add_index :export_refund_nomenclature_indents, :export_refund_nomenclature_indents_sid, unique: true, name: :primary_key
  end

  def down
    # AdditionalCode
    remove_index :additional_codes, name: :primary_key
    remove_index :additional_codes, name: :type_id

    # AdditionalCodeDescription
    remove_index :additional_code_descriptions, name: :primary_key
    remove_index :additional_code_descriptions, name: :period_sid
    remove_index :additional_code_descriptions, name: :language_id
    remove_index :additional_code_descriptions, name: :type_id
    remove_index :additional_code_descriptions, name: :sid

    # AdditionalCodeDescriptionPeriod
    remove_index :additional_code_description_periods, name: :primary_key
    remove_index :additional_code_description_periods, name: :description_period_sid
    remove_index :additional_code_description_periods, name: :code_type_id

    # AdditionalCodeType
    remove_index :additional_code_types, name: :primary_key
    remove_index :additional_code_types, :meursing_table_plan_id

    # AdditionalCodeTypeDescription
    remove_index :additional_code_type_descriptions, name: :primary_key
    remove_index :additional_code_type_descriptions, :language_id

    # AdditionalCodeTypeDescription
    remove_index :additional_code_type_measure_types, name: :primary_key

    # BaseRegulation
    remove_index :base_regulations, name: :primary_key
    remove_index :base_regulations, :regulation_group_id
    remove_index :base_regulations, name: :explicit_abrogation_regulation
    remove_index :base_regulations, name: :complete_abrogation_regulation
    remove_index :base_regulations, name: :antidumping_regulation

    # Certificate
    remove_index :certificates, name: :primary_key

    # CertificateDescription
    remove_index :certificate_descriptions, name: :primary_key
    remove_index :certificate_descriptions, name: :certificate
    remove_index :certificate_descriptions, :language_id

    # CertificateDescriptionPeriod
    remove_index :certificate_description_periods, name: :primary_key
    remove_index :certificate_description_periods, name: :certificate

    # CertificateType
    remove_index :certificate_types, name: :primary_key

    # CertificateTypeDescription
    remove_index :certificate_type_descriptions, name: :primary_key
    remove_index :certificate_type_descriptions, :language_id

    # CompleteAbrogationRegulation
    remove_index :complete_abrogation_regulations, name: :primary_key

    # DutyExpression
    remove_index :duty_expressions, name: :primary_key

    # DutyExpressionDescription
    remove_index :duty_expression_descriptions, name: :primary_key
    remove_index :duty_expression_descriptions, :language_id

    # ExplicitAbrogationRegulation
    remove_index :explicit_abrogation_regulations, name: :primary_key

    # ExportRefundNomenclature
    remove_index :export_refund_nomenclatures, name: :primary_key
    remove_index :export_refund_nomenclatures, :goods_nomenclature_sid

    # ExportRefundNomenclatureDescription
    remove_index :export_refund_nomenclature_descriptions, name: :primary_key
    remove_index :export_refund_nomenclature_descriptions, name: :export_refund_nomenclature
    remove_index :export_refund_nomenclature_descriptions, :language_id

    # ExportRefundNomenclatureDescriptionPeriod
    remove_index :export_refund_nomenclature_description_periods, name: :primary_key

    # ExportRefundNomenclatureIndent
    remove_index :export_refund_nomenclature_indents, name: :primary_key
  end
end
