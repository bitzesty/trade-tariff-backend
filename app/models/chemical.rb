class Chemical < Sequel::Model
  many_to_many :goods_nomenclatures, join_table: :chemicals_goods_nomenclatures, right_key: :goods_nomenclature_sid, left_key: :chemical_id
  one_to_many :chemical_names

  def validate
    super
    errors.add(:cas, 'is missing') if cas.blank?
    errors.add(:cas, 'must be unique') if Chemical.where(cas: cas).any?
  end

  def name
    chemical_names.map(&:name).join('; ')
  end

  def goods_nomenclature_ids
    goods_nomenclatures.map(&:goods_nomenclature_sid)
  end

  def goods_nomenclature_map
    obj = {}
    goods_nomenclatures.each do |gn|
      obj[gn.goods_nomenclature_sid] = gn.goods_nomenclature_item_id
    end
    obj
  end

  def chemical_name_ids
    chemical_names.map(&:id)
  end

  def id_to_s
    id.to_s
  end
end
