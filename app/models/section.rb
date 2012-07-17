class Section < Sequel::Model
  many_to_many :chapters, right_key: :goods_nomenclature_sid,
                          join_table: :chapters_sections
end
