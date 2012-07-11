class AddEndDatesToValidityDateBoundedModels < ActiveRecord::Migration
  def up
    add_column :additional_code_description_periods, :validity_end_date, :date
    add_column :certificate_description_periods, :validity_end_date, :date
    add_column :export_refund_nomenclature_description_periods, :validity_end_date, :date
    add_column :export_refund_nomenclature_indents, :validity_end_date, :date
    add_column :footnote_description_periods, :validity_end_date, :date
    add_column :geographical_area_description_periods, :validity_end_date, :date
    add_column :goods_nomenclature_description_periods, :validity_end_date, :date
    add_column :goods_nomenclature_indents, :validity_end_date, :date
    add_column :meursing_additional_codes, :validity_end_date, :date
  end

  def down
    remove_column :additional_code_description_periods, :validity_end_date
    remove_column :certificate_description_periods, :validity_end_date
    remove_column :export_refund_nomenclature_description_periods, :validity_end_date
    remove_column :export_refund_nomenclature_indents, :validity_end_date
    remove_column :footnote_description_periods, :validity_end_date
    remove_column :geographical_area_description_periods, :validity_end_date
    remove_column :goods_nomenclature_description_periods, :validity_end_date
    remove_column :goods_nomenclature_indents, :validity_end_date
    remove_column :meursing_additional_codes, :validity_end_date
  end
end
