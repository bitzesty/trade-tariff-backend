class Chemical < Sequel::Model
  many_to_many :goods_nomenclatures, join_table: :chemicals_goods_nomenclatures, right_key: :goods_nomenclature_sid, left_key: :chemical_id
  one_to_many :chemical_names

  def name
    chemical_names.map(&:name).join('; ')
  end
end
