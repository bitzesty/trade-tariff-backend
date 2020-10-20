Sequel.migration do
  up do
    alter_table :chapters_sections do
      drop_index [:goods_nomenclature_sid, :section_id], name: :index_chapters_sections_on_goods_nomenclature_sid_and_section_id
      add_index [:goods_nomenclature_sid, :section_id], unique: true, name: :index_chapters_sections_on_goods_nomenclature_sid_and_section_id
    end
  end

  down do
    alter_table :chapters_sections do
      drop_index [:goods_nomenclature_sid, :section_id], name: :index_chapters_sections_on_goods_nomenclature_sid_and_section_id
      add_index [:goods_nomenclature_sid, :section_id], name: :index_chapters_sections_on_goods_nomenclature_sid_and_section_id
    end
  end
end
