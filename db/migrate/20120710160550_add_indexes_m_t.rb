class AddIndexesMT < ActiveRecord::Migration
  def up
    # Measure
    add_index :measures, :measure_sid, unique: true, name: :primary_key
    add_index :measures, :goods_nomenclature_sid
    add_index :measures, [:justification_regulation_role, :justification_regulation_id], name: :justification_regulation
    add_index :measures, [:measure_generating_regulation_role, :measure_generating_regulation_id], name: :measure_generating_regulation
    add_index :measures, :measure_type
    add_index :measures, :additional_code_sid
    add_index :measures, :geographical_area_sid

    # MeasureAction
    add_index :measure_actions, :action_code, unique: true, name: :primary_key

    # MeasureActionDescription
    add_index :measure_action_descriptions, :action_code, unique: true, name: :primary_key

    # MeasureComponent
    add_index :measure_components, [:measure_sid, :duty_expression_id], unique: true, name: :primary_key
    add_index :measure_components, :measurement_unit_code
    add_index :measure_components, :measurement_unit_qualifier_code
    add_index :measure_components, :monetary_unit_code

    # MeasureCondition
    add_index :measure_conditions, :measure_condition_sid, unique: true, name: :primary_key
    add_index :measure_conditions, :measure_sid
    add_index :measure_conditions, :action_code
    add_index :measure_conditions, :condition_monetary_unit_code
    add_index :measure_conditions, :condition_measurement_unit_code
    add_index :measure_conditions, :condition_measurement_unit_qualifier_code,
                                   name: :condition_measurement_unit_qualifier_code
    add_index :measure_conditions, [:certificate_code, :certificate_type_code], name: :certificate

    # MeasureConditionCode
    add_index :measure_condition_codes, :condition_code, unique: true, name: :primary_key

    # MeasureConditionCodeDescription
    add_index :measure_condition_code_descriptions, :condition_code, unique: true, name: :primary_key

    # MeasureConditionComponent
    add_index :measure_condition_components, [:measure_condition_sid, :duty_expression_id], unique: true, name: :primary_key
    add_index :measure_condition_components, :duty_expression_id # remove me
    add_index :measure_condition_components, :measurement_unit_code
    add_index :measure_condition_components, :measurement_unit_qualifier_code,
                                             name: :measurement_unit_qualifier_code
    add_index :measure_condition_components, :monetary_unit_code

    # MeasureExcludedGeographicalArea
    add_index :measure_excluded_geographical_areas, [:measure_sid, :geographical_area_sid], unique: true, name: :primary_key

    # MeasurePartialTemporaryStop
    add_index :measure_partial_temporary_stops, [:measure_sid, :partial_temporary_stop_regulation_id], unique: true, name: :primary_key
    add_index :measure_partial_temporary_stops, :abrogation_regulation_id,
                                                name: :abrogation_regulation_id

    # MeasureType
    add_index :measure_types, :measure_type_id, unique: true, name: :primary_key
    add_index :measure_types, :measure_type_series_id

    # MeasureTypeDescription
    add_index :measure_type_descriptions, :measure_type_id, unique: true, name: :primary_key
    add_index :measure_type_descriptions, :language_id

    # MeasureTypeSeries
    add_index :measure_type_series, :measure_type_series_id, unique: true, name: :primary_key

    # MeasureTypeSeriesDescription
    add_index :measure_type_series_descriptions, :measure_type_series_id, unique: true, name: :primary_key
    add_index :measure_type_series_descriptions, :language_id

    # Measurement
    add_index :measurements, [:measurement_unit_code, :measurement_unit_qualifier_code], unique: true, name: :primary_key

    # MeasurementUnit
    add_index :measurement_units, :measurement_unit_code, unique: true, name: :primary_key

    # MeasurementUnitDescription
    add_index :measurement_unit_descriptions, :measurement_unit_code, unique: true, name: :primary_key
    add_index :measurement_unit_descriptions, :language_id

    # MeasurementUnitQualifier
    add_index :measurement_unit_qualifiers, :measurement_unit_qualifier_code, unique: true, name: :primary_key

    # MeasurementUnitQualifier
    add_index :measurement_unit_qualifier_descriptions, :measurement_unit_qualifier_code, unique: true, name: :primary_key

    # MeursingAdditionalCode
    add_index :meursing_additional_codes, :meursing_additional_code_sid, unique: true, name: :primary_key

    # MeursingHeading
    add_index :meursing_headings, [:meursing_table_plan_id, :meursing_heading_number, :row_column_code], unique: true, name: :primary_key

    # MeursingHeadingText
    add_index :meursing_heading_texts, [:meursing_table_plan_id, :meursing_heading_number, :row_column_code], unique: true, name: :primary_key

    # MeursingSubheading
    add_index :meursing_subheadings, [:meursing_table_plan_id, :meursing_heading_number, :row_column_code, :subheading_sequence_number], unique: true, name: :primary_key

    # MeursingTableCellComponent
    add_index :meursing_table_cell_components, [:meursing_table_plan_id, :heading_number, :row_column_code, :meursing_additional_code_sid], unique: true, name: :primary_key

    # MeursingTablePlan
    add_index :meursing_table_plans, :meursing_table_plan_id, unique: true, name: :primary_key

    # ModificationRegulation
    add_index :modification_regulations, [:modification_regulation_id, :modification_regulation_role], unique: true, name: :primary_key
    add_index :modification_regulations, [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role], name: :explicit_abrogation_regulation
    add_index :modification_regulations, [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role], name: :complete_abrogation_regulation
    add_index :modification_regulations, [:base_regulation_id, :base_regulation_role], name: :base_regulation

    # MonetaryExchangePeriod
    add_index :monetary_exchange_periods, [:monetary_exchange_period_sid, :parent_monetary_unit_code], unique: true, name: :primary_key

    # MonetaryExchangeRate
    add_index :monetary_exchange_rates, [:monetary_exchange_period_sid, :child_monetary_unit_code], unique: true, name: :primary_key

    # MonetaryUnit
    add_index :monetary_units, :monetary_unit_code, unique: true, name: :primary_key

    # MonetaryUnitDescription
    add_index :monetary_unit_descriptions, :monetary_unit_code, unique: true, name: :primary_key
    add_index :monetary_unit_descriptions, :language_id

    # NomenclatureGroupMembership
    add_index :nomenclature_group_memberships, [:goods_nomenclature_sid, :goods_nomenclature_group_id,
                                                :goods_nomenclature_group_type, :goods_nomenclature_item_id,
                                                :validity_start_date], unique: true, name: :primary_key

    # ProrogationRegulation
    add_index :prorogation_regulations, [:prorogation_regulation_id, :prorogation_regulation_role], unique: true, name: :primary_key

    # ProrogationRegulationAction
    add_index :prorogation_regulation_actions, [:prorogation_regulation_id, :prorogation_regulation_role,
                                                :prorogated_regulation_id, :prorogated_regulation_role], unique: true, name: :primary_key

    # QuotaAssociation
    add_index :quota_associations, [:main_quota_definition_sid, :sub_quota_definition_sid], unique: true, name: :primary_key

    # QuotaBalanceEvent
    add_index :quota_balance_events, [:quota_definition_sid, :occurrence_timestamp], unique: true, name: :primary_key

    # QuotaBlockingPeriod
    add_index :quota_blocking_periods, :quota_blocking_period_sid, unique: true, name: :primary_key

    # QuotaCriticalEvent
    add_index :quota_critical_events, [:quota_definition_sid, :occurrence_timestamp], unique: true, name: :primary_key

    # QuotaDefinition
    add_index :quota_definitions, :quota_definition_sid, unique: true, name: :primary_key
    add_index :quota_definitions, :quota_order_number_id
    add_index :quota_definitions, :measurement_unit_code
    add_index :quota_definitions, :measurement_unit_qualifier_code
    add_index :quota_definitions, :monetary_unit_code

    # QuotaExhaustionEvent
    add_index :quota_exhaustion_events, [:quota_definition_sid, :occurrence_timestamp], unique: true, name: :primary_key

    # QuotaOrderNumber
    add_index :quota_order_numbers, :quota_order_number_sid, unique: true, name: :primary_key

    # QuotaOrderNumberOrigin
    add_index :quota_order_number_origins, :quota_order_number_origin_sid, unique: true, name: :primary_key
    add_index :quota_order_number_origins, :geographical_area_sid

    # QuotaOrderNumberOriginExclusion
    add_index :quota_order_number_origin_exclusions, [:quota_order_number_origin_sid, :excluded_geographical_area_sid], unique: true, name: :primary_key

    # QuotaReopeningEvent
    add_index :quota_reopening_events, [:quota_definition_sid, :occurrence_timestamp], unique: true, name: :primary_key

    # QuotaSuspensionPeriod
    add_index :quota_suspension_periods, :quota_suspension_period_sid, unique: true, name: :primary_key
    add_index :quota_suspension_periods, :quota_definition_sid

    # QuotaUnblockingEvent
    add_index :quota_unblocking_events, [:quota_definition_sid, :occurrence_timestamp], unique: true, name: :primary_key

    # QuotaUnsuspensionEvent
    add_index :quota_unsuspension_events, [:quota_definition_sid, :occurrence_timestamp], unique: true, name: :primary_key

    # RegulationGroup
    add_index :regulation_groups, :regulation_group_id, unique: true, name: :primary_key

    # RegulationGroupDescription
    add_index :regulation_group_descriptions, :regulation_group_id, unique: true, name: :primary_key
    add_index :regulation_group_descriptions, :language_id

    # RegulationReplacement
    add_index :regulation_replacements, [:replacing_regulation_id, :replacing_regulation_role,
                                         :replaced_regulation_id, :replaced_regulation_role,
                                         :measure_type_id, :geographical_area_id, :chapter_heading], unique: true, name: :primary_key

    # RegulationRoleType
    add_index :regulation_role_types, :regulation_role_type_id, unique: true, name: :primary_key

    # RegulationRoleTypeDescription
    add_index :regulation_role_type_descriptions, :regulation_role_type_id, unique: true, name: :primary_key
    add_index :regulation_role_type_descriptions, :language_id

    # TransmissionComment
    add_index :transmission_comments, [:comment_sid, :language_id], unique: true, name: :primary_key
  end

  def down
    # Measure
    remove_index :measures, name: :primary_key
    remove_index :measures, :goods_nomenclature_sid
    remove_index :measures, name: :justification_regulation
    remove_index :measures, name: :measure_generating_regulation
    remove_index :measures, :measure_type
    remove_index :measures, :additional_code_sid
    remove_index :measures, :geographical_area_sid

    # MeasureAction
    remove_index :measure_actions, name: :primary_key

    # MeasureActionDescription
    remove_index :measure_action_descriptions, name: :primary_key

    # MeasureComponent
    remove_index :measure_components, name: :primary_key
    remove_index :measure_components, :measurement_unit_code
    remove_index :measure_components, :measurement_unit_qualifier_code
    remove_index :measure_components, :monetary_unit_code

    # MeasureCondition
    remove_index :measure_conditions, name: :primary_key
    remove_index :measure_conditions, :measure_sid
    remove_index :measure_conditions, :action_code
    remove_index :measure_conditions, :condition_monetary_unit_code
    remove_index :measure_conditions, :condition_measurement_unit_code
    remove_index :measure_conditions, name: :condition_measurement_unit_qualifier_code
    remove_index :measure_conditions, name: :certificate

    # MeasureConditionCode
    remove_index :measure_condition_codes, name: :primary_key

    # MeasureConditionCodeDescription
    remove_index :measure_condition_code_descriptions, name: :primary_key

    # MeasureConditionComponent
    remove_index :measure_condition_components, name: :primary_key
    remove_index :measure_condition_components, :duty_expression_id # remove me
    remove_index :measure_condition_components, :measurement_unit_code
    remove_index :measure_condition_components, name: :measurement_unit_qualifier_code
    remove_index :measure_condition_components, :monetary_unit_code

    # MeasureExcludedGeographicalArea
    remove_index :measure_excluded_geographical_areas, name: :primary_key

    # MeasurePartialTemporaryStop
    remove_index :measure_partial_temporary_stops, name: :primary_key
    remove_index :measure_partial_temporary_stops, name: :abrogation_regulation_id

    # MeasureType
    remove_index :measure_types, name: :primary_key
    remove_index :measure_types, :measure_type_series_id

    # MeasureTypeDescription
    remove_index :measure_type_descriptions, name: :primary_key
    remove_index :measure_type_descriptions, :language_id

    # MeasureTypeSeries
    remove_index :measure_type_series, name: :primary_key

    # MeasureTypeSeriesDescription
    remove_index :measure_type_series_descriptions, name: :primary_key
    remove_index :measure_type_series_descriptions, :language_id

    # Measurement
    remove_index :measurements, name: :primary_key

    # MeasurementUnit
    remove_index :measurement_units, name: :primary_key

    # MeasurementUnitDescription
    remove_index :measurement_unit_descriptions, name: :primary_key
    remove_index :measurement_unit_descriptions, :language_id

    # MeasurementUnitQualifier
    remove_index :measurement_unit_qualifiers, name: :primary_key

    # MeasurementUnitQualifier
    remove_index :measurement_unit_qualifier_descriptions, name: :primary_key

    # MeursingAdditionalCode
    remove_index :meursing_additional_codes, name: :primary_key

    # MeursingHeading
    remove_index :meursing_headings, name: :primary_key

    # MeursingHeadingText
    remove_index :meursing_heading_texts, name: :primary_key

    # MeursingSubheading
    remove_index :meursing_subheadings, name: :primary_key

    # MeursingTableCellComponent
    remove_index :meursing_table_cell_components, name: :primary_key

    # MeursingTablePlan
    remove_index :meursing_table_plans, name: :primary_key

    # ModificationRegulation
    remove_index :modification_regulations, name: :primary_key
    remove_index :modification_regulations, name: :explicit_abrogation_regulation
    remove_index :modification_regulations, name: :complete_abrogation_regulation
    remove_index :modification_regulations, name: :base_regulation

    # MonetaryExchangePeriod
    remove_index :monetary_exchange_periods, name: :primary_key

    # MonetaryExchangeRate
    remove_index :monetary_exchange_rates, name: :primary_key

    # MonetaryUnit
    remove_index :monetary_units, name: :primary_key

    # MonetaryUnitDescription
    remove_index :monetary_unit_descriptions, name: :primary_key
    remove_index :monetary_unit_descriptions, :language_id

    # NomenclatureGroupMembership
    remove_index :nomenclature_group_memberships, name: :primary_key

    # ProrogationRegulation
    remove_index :prorogation_regulations, name: :primary_key

    # ProrogationRegulationAction
    remove_index :prorogation_regulation_actions, name: :primary_key

    # QuotaAssociation
    remove_index :quota_associations, name: :primary_key

    # QuotaBalanceEvent
    remove_index :quota_balance_events, name: :primary_key

    # QuotaBlockingPeriod
    remove_index :quota_blocking_periods, name: :primary_key

    # QuotaBlockingPeriod
    remove_index :quota_critical_events, name: :primary_key

    # QuotaDefinition
    remove_index :quota_definitions, name: :primary_key
    remove_index :quota_definitions, :quota_order_number_id
    remove_index :quota_definitions, :measurement_unit_code
    remove_index :quota_definitions, :measurement_unit_qualifier_code
    remove_index :quota_definitions, :monetary_unit_code

    # QuotaExhaustionEvent
    remove_index :quota_exhaustion_events, name: :primary_key

    # QuotaOrderNumber
    remove_index :quota_order_numbers, name: :primary_key

    # QuotaOrderNumberOrigin
    remove_index :quota_order_number_origins, name: :primary_key
    remove_index :quota_order_number_origins, :geographical_area_sid

    # QuotaOrderNumberOriginExclusion
    remove_index :quota_order_number_origin_exclusions, name: :primary_key

    # QuotaReopeningEvent
    remove_index :quota_reopening_events, name: :primary_key

    # QuotaSuspensionPeriod
    remove_index :quota_suspension_periods, name: :primary_key
    remove_index :quota_suspension_periods, :quota_definition_sid

    # QuotaUnblockingEvent
    remove_index :quota_unblocking_events, name: :primary_key

    # QuotaUnsuspensionEvent
    remove_index :quota_unsuspension_events, name: :primary_key

    # RegulationGroup
    remove_index :regulation_groups, name: :primary_key

    # RegulationGroupDescription
    remove_index :regulation_group_descriptions, name: :primary_key
    remove_index :regulation_group_descriptions, :language_id

    # RegulationReplacement
    remove_index :regulation_replacements, name: :primary_key

    # RegulationRoleType
    remove_index :regulation_role_types, name: :primary_key

    # RegulationRoleTypeDescription
    remove_index :regulation_role_type_descriptions, name: :primary_key
    remove_index :regulation_role_type_descriptions, :language_id

    # TransmissionComment
    remove_index :transmission_comments, name: :primary_key
  end
end
