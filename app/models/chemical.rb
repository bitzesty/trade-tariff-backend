class Chemical < Sequel::Model
  plugin :auditable

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

  def save_with_name(name)
    errors = []
    status = :created
    Sequel::Model.db.transaction do
      save raise_on_failure: false
      begin
        chemical_name = reload.add_chemical_name name: name
      rescue Sequel::ValidationFailed
        errors << chemical_name.stringify_sequel_errors
        status = :unprocessable_entity
      end
    end
    [errors, status]
  end

  def update_cas_and_or_name(new_cas:, chemical_name_id:, new_chemical_name:)
    errors = []
    Sequel::Model.db.transaction do
      if new_cas.present?
        update(cas: new_cas)
      end

      if chemical_name_id.present?
        errors, status = ChemicalName.find(id: chemical_name_id).update_with_name(new_chemical_name)
      end
    rescue StandardError
      errors << "Chemical was not updated: chemical.id: #{id}, cas: #{cas}, chemical_name_id: #{chemical_name_id}, new_chemical_name: #{new_chemical_name}"
      status = :not_found
    end
  end
end
