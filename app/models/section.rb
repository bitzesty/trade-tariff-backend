class Section < Sequel::Model
  include Tire::Model::Search

  plugin :json_serializer

  many_to_many :chapters, dataset: -> {
    Chapter.join_table(:inner, :chapters_sections, chapters_sections__goods_nomenclature_sid: :goods_nomenclatures__goods_nomenclature_sid)
           .join_table(:inner, :sections, chapters_sections__section_id: :sections__id)
           .with_actual(Chapter)
           .where(sections__id: id)
  }

  # Tire configuration
  tire do
    index_name    'sections'
    document_type 'section'

    mapping do
      indexes :title,        analyzer: 'snowball'
    end
  end

  def to_param
    position
  end

  def to_indexed_json
    {
      id: id,
      numeral: numeral,
      title: title,
      position: position
    }.to_json
  end
end
