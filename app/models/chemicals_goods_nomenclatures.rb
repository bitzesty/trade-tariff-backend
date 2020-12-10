class ChemicalsGoodsNomenclatures < Sequel::Model
attr_accessor :chemical
attr_accessor :commodity
  class << self
    def create_map(commodity:, chemical:)
      status = :conflict
      existing_map = ChemicalsGoodsNomenclatures.find(
        chemical_id: chemical.id,
        goods_nomenclature_sid: commodity.id
      )
      if existing_map.present?
        errors = []
        errors << "Mapping already exists: chemical_id: #{chemical.id}, goods_nomenclature_sid: #{commodity.id}"
        return [errors, status]
      end

      if chemical.present? && commodity.present?
        errors, status = create_chemical_commodity_mapping(commodity: commodity, chemical: chemical)
        map = ChemicalsGoodsNomenclatures.find(
          chemical_id: chemical.id,
          goods_nomenclature_sid: commodity.id
        )
        unless map.present?
          errors << "Newly created mapping was not found: chemical_id: #{chemical&.id}, goods_nomenclature_sid: #{commodity&.id}"
          status = :internal_server_error
        end
      else
        errors << "Target commodity and/or chemical missing: chemical.id: #{chemical&.id}, goods_nomenclature_sid: #{commodity&.id}"
        status = :not_found
      end
      [errors, status]
    end

    def update_map(chemical:, map:, commodity:, new_commodity:)
      errors = []
      status = :not_found
      if chemical.present? && map.present? && new_commodity.present?
        errors, status = update_chemical_commodity_mapping(chemical: chemical, map: map, commodity: commodity, new_commodity: new_commodity)
      else
        errors << "Mapping was not updated: chemical.id: #{chemical&.id}, old_gn: #{map&.goods_nomenclature_sid}, new_gn: #{new_commodity&.goods_nomenclature_item_id}"
      end
      [errors, status]
    end

    private

    def create_chemical_commodity_mapping(commodity:, chemical:)
      errors = []
      status = :unprocessable_entity
      begin
        ChemicalsGoodsNomenclatures.insert(
          chemical_id: chemical.id,
          goods_nomenclature_sid: commodity.id
        )
        status = :created
      rescue StandardError
        errors << "Mapping was not created: chemical_id: #{chemical.id}, goods_nomenclature_sid: #{commodity.id}"
      end
      [errors, status]
    end
    
    def update_chemical_commodity_mapping(chemical:, map:, commodity:, new_commodity:)
      errors = []
      status = :conflict
      Sequel::Model.db.transaction do
        unrestrict_primary_key
        create(
          chemical_id: chemical.id,
          goods_nomenclature_sid: new_commodity.id
        )
        map.destroy
        status = :ok
      rescue StandardError
        errors << "Mapping already exists: chemical_id: #{chemical.id}, goods_nomenclature_sid: #{commodity.id}"
      end
      [errors, status]
    end
  end
end
