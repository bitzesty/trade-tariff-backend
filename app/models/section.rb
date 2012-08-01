class Section < Sequel::Model
  plugin :json_serializer

  many_to_many :chapters, dataset: -> {
    Chapter.join_table(:inner, :chapters_sections, chapters_sections__goods_nomenclature_sid: :goods_nomenclatures__goods_nomenclature_sid)
           .join_table(:inner, :sections, chapters_sections__section_id: :sections__id)
           .with_actual(Chapter)
           .where(sections__id: id)
  }

  def to_param
    position
  end
end
