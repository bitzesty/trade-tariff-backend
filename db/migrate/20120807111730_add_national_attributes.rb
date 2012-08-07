Sequel.migration do
  up do
    add_column :regulation_groups, :national, TrueClass
    add_column :regulation_group_descriptions, :national, TrueClass
    add_column :regulation_role_types, :national, TrueClass
    add_column :regulation_role_type_descriptions, :national, TrueClass
    add_column :base_regulations, :national, TrueClass
    add_column :measure_types, :national, TrueClass
    add_column :measure_type_descriptions, :national, TrueClass
    add_column :additional_code_types, :national, TrueClass
    add_column :additional_code_type_descriptions, :national, TrueClass
    add_column :additional_code_type_measure_types, :national, TrueClass
    add_column :additional_codes, :national, TrueClass
    add_column :additional_code_descriptions, :national, TrueClass
    add_column :footnote_types, :national, TrueClass
    add_column :footnote_type_descriptions, :national, TrueClass
    add_column :footnotes, :national, TrueClass
    add_column :footnote_description_periods, :national, TrueClass
    add_column :footnote_descriptions, :national, TrueClass
    add_column :certificates, :national, TrueClass
    add_column :certificate_descriptions, :national, TrueClass
    add_column :certificate_types, :national, TrueClass
    add_column :certificate_type_descriptions, :national, TrueClass
    add_column :geographical_area_memberships, :national, TrueClass
    add_column :geographical_areas, :national, TrueClass
    add_column :geographical_area_descriptions, :national, TrueClass
    add_column :geographical_area_description_periods, :national, TrueClass
    add_column :footnote_association_goods_nomenclatures, :national, TrueClass
    add_column :footnote_association_measures, :national, TrueClass
  end

  down do
    drop_column :regulation_groups, :national
    drop_column :regulation_group_descriptions, :national
    drop_column :regulation_role_types, :national
    drop_column :regulation_role_type_descriptions, :national
    drop_column :base_regulations, :national
    drop_column :measure_types, :national
    drop_column :measure_type_descriptions, :national
    drop_column :additional_code_types, :national
    drop_column :additional_code_type_descriptions, :national
    drop_column :additional_code_type_measure_types, :national
    drop_column :additional_codes, :national
    drop_column :additional_code_descriptions, :national
    drop_column :footnote_types, :national
    drop_column :footnote_type_descriptions, :national
    drop_column :footnotes, :national
    drop_column :footnote_description_periods, :national
    drop_column :footnote_descriptions, :national
    drop_column :certificates, :national
    drop_column :certificate_descriptions, :national
    drop_column :certificate_types, :national
    drop_column :certificate_type_descriptions, :national
    drop_column :geographical_area_memberships, :national
    drop_column :geographical_areas, :national
    drop_column :geographical_area_descriptions, :national
    drop_column :geographical_area_description_periods, :national
    drop_column :footnote_association_goods_nomenclatures, :national
    drop_column :footnote_association_measures, :national
  end
end
