class Section < Sequel::Model
  plugin :json_serializer

  many_to_many :chapters, right_key: :goods_nomenclature_sid,
                          join_table: :chapters_sections

  def identifier
    position
  end
end
