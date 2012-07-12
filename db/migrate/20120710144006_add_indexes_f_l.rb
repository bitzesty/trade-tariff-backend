class AddIndexesFL < ActiveRecord::Migration
  def up
    # Footnote
    add_index :footnotes, [:footnote_id, :footnote_type_id], unique: true, name: :primary_key

    # FootnoteAssociationAdditionalCode
    add_index :footnote_association_additional_codes, [:footnote_id, :footnote_type_id, :additional_code_sid], unique: true, name: :primary_key
    add_index :footnote_association_additional_codes, :additional_code_type_id,
                                                      name: :additional_code_type

    # FootnoteAssociationErn
    add_index :footnote_association_erns, [:export_refund_nomenclature_sid, :footnote_id, :footnote_type, :validity_start_date], unique: true, name: :primary_key

    # FootnoteAssociationGoodsNomenclature
    add_index :footnote_association_goods_nomenclatures, [:footnote_id, :footnote_type, :goods_nomenclature_sid, :validity_start_date], unique: true, name: :primary_key

    # FootnoteAssociationMeasure
    add_index :footnote_association_measures, [:measure_sid, :footnote_id, :footnote_type_id], unique: true, name: :primary_key

    # FootnoteAssociationMeursingHeading
    add_index :footnote_association_meursing_headings, [:footnote_id, :meursing_table_plan_id], unique: true, name: :primary_key

    # FootnoteDescription
    add_index :footnote_descriptions, [:footnote_id, :footnote_type_id, :footnote_description_period_sid], unique: true, name: :primary_key
    add_index :footnote_descriptions, :language_id

    # FootnoteDescriptionPeriod
    add_index :footnote_description_periods, [:footnote_id, :footnote_type_id, :footnote_description_period_sid], unique: true, name: :primary_key

    # FootnoteType
    add_index :footnote_types, :footnote_type_id, unique: true, name: :primary_key

    # FootnoteTypeDescription
    add_index :footnote_type_descriptions, :footnote_type_id, unique: true, name: :primary_key
    add_index :footnote_type_descriptions, :language_id

    # FtsRegulationAction
    add_index :fts_regulation_actions, [:fts_regulation_id, :fts_regulation_role,
                                        :stopped_regulation_id, :stopped_regulation_role], unique: true, name: :primary_key

    # FullTemporaryStopRegulation
    add_index :full_temporary_stop_regulations, [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role], unique: true, name: :primary_key
    add_index :full_temporary_stop_regulations, [:explicit_abrogation_regulation_role, :explicit_abrogation_regulation_id], name: :explicit_abrogation_regulation

    # GeographicalArea
    add_index :geographical_areas, :geographical_area_sid, unique: true, name: :primary_key
    add_index :geographical_areas, :parent_geographical_area_group_sid

    # GeographicalAreaDescription
    add_index :geographical_area_descriptions, [:geographical_area_description_period_sid,
                                                :geographical_area_sid], unique: true, name: :primary_key
    add_index :geographical_area_descriptions, :language_id

    # GeographicalAreaDescriptionPeriod
    add_index :geographical_area_description_periods, [:geographical_area_description_period_sid, :geographical_area_sid], unique: true, name: :primary_key

    # GeographicalAreaMembership
    add_index :geographical_area_memberships, [:geographical_area_sid, :geographical_area_group_sid, :validity_start_date], unique: true, name: :primary_key

    # GoodsNomenclature
    add_index :goods_nomenclatures, :goods_nomenclature_sid, unique: true, name: :primary_key
    add_index :goods_nomenclatures, [:goods_nomenclature_item_id, :producline_suffix], name: :item_id

    # GoodsNomenclatureDescription
    add_index :goods_nomenclature_descriptions, [:goods_nomenclature_sid, :goods_nomenclature_description_period_sid], unique: true, name: :primary_key
    add_index :goods_nomenclature_descriptions, :language_id

    # GoodsNomenclatureDescriptionPeriod
    add_index :goods_nomenclature_description_periods, :goods_nomenclature_description_period_sid, unique: true, name: :primary_key

    # GoodsNomenclatureGroup
    add_index :goods_nomenclature_groups, [:goods_nomenclature_group_id, :goods_nomenclature_group_type], unique: true, name: :primary_key

    # GoodsNomenclatureGroupDescription
    add_index :goods_nomenclature_group_descriptions, [:goods_nomenclature_group_id, :goods_nomenclature_group_type], unique: true, name: :primary_key
    add_index :goods_nomenclature_group_descriptions, :language_id

    # GoodsNomenclatureIndent
    add_index :goods_nomenclature_indents, :goods_nomenclature_indent_sid, unique: true, name: :primary_key

    GoodsNomenclatureOrigin
    add_index :goods_nomenclature_origins, [:goods_nomenclature_sid, :derived_goods_nomenclature_item_id, :derived_productline_suffix, :goods_nomenclature_item_id, :productline_suffix], unique: true, name: :primary_key

    GoodsNomenclatureSuccessor
    add_index :goods_nomenclature_successors, [:goods_nomenclature_sid, :absorbed_goods_nomenclature_item_id, :absorbed_productline_suffix, :goods_nomenclature_item_id, :productline_suffix], unique: true, name: :primary_key

    # Language
    add_index :languages, :language_id, unique: true, name: :primary_key

    # LanguageDescription
    add_index :language_descriptions, [:language_id, :language_code_id], unique: true, name: :primary_key
  end

  def down
    # Footnote
    remove_index :footnotes, name: :primary_key

    # FootnoteAssociationAdditionalCode
    remove_index :footnote_association_additional_codes, name: :primary_key
    remove_index :footnote_association_additional_codes, name: :additional_code_type

    # FootnoteAssociationErn
    remove_index :footnote_association_erns, name: :primary_key

    # FootnoteAssociationGoodsNomenclature
    remove_index :footnote_association_goods_nomenclatures, name: :primary_key

    # FootnoteAssociationMeasure
    remove_index :footnote_association_measures, name: :primary_key

    # FootnoteAssociationMeursingHeading
    remove_index :footnote_association_meursing_headings, name: :primary_key

    # FootnoteDescription
    remove_index :footnote_descriptions, name: :primary_key
    remove_index :footnote_descriptions, :language_id

    # FootnoteDescriptionPeriod
    remove_index :footnote_description_periods, name: :primary_key

    # FootnoteType
    remove_index :footnote_types, name: :primary_key

    # FootnoteTypeDescription
    remove_index :footnote_type_descriptions, name: :primary_key
    remove_index :footnote_type_descriptions, :language_id

    # FtsRegulationAction
    remove_index :fts_regulation_actions, name: :primary_key

    # FullTemporaryStopRegulation
    remove_index :full_temporary_stop_regulations, name: :primary_key
    remove_index :full_temporary_stop_regulations, name: :explicit_abrogation_regulation

    # GeographicalArea
    remove_index :geographical_areas, name: :primary_key
    remove_index :geographical_areas, :parent_geographical_area_group_sid

    # GeographicalAreaDescription
    remove_index :geographical_area_descriptions, name: :primary_key
    remove_index :geographical_area_descriptions, :language_id

    # GeographicalAreaDescriptionPeriod
    remove_index :geographical_area_description_periods, name: :primary_key

    # GeographicalAreaMembership
    remove_index :geographical_area_memberships, name: :primary_key

    # GoodsNomenclature
    remove_index :goods_nomenclatures, name: :primary_key
    # remove_index :goods_nomenclatures, name: :item_id

    # GoodsNomenclatureDescription
    remove_index :goods_nomenclature_descriptions, name: :primary_key
    remove_index :goods_nomenclature_descriptions, :language_id

    # GoodsNomenclatureDescriptionPeriod
    remove_index :goods_nomenclature_description_periods, name: :primary_key

    # GoodsNomenclatureGroup
    remove_index :goods_nomenclature_groups, name: :primary_key

    # GoodsNomenclatureGroupDescription
    remove_index :goods_nomenclature_group_descriptions, name: :primary_key
    remove_index :goods_nomenclature_group_descriptions, :language_id

    # GoodsNomenclatureIndent
    remove_index :goods_nomenclature_indents, name: :primary_key

    # GoodsNomenclatureOrigin
    remove_index :goods_nomenclature_origins, name: :primary_key

    # GoodsNomenclatureSuccessor
    remove_index :goods_nomenclature_successors, name: :primary_key

    # Language
    remove_index :languages, name: :primary_key

    # LanguageDescription
    remove_index :language_descriptions, name: :primary_key
  end
end
