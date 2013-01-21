class GoodsNomenclatureAssociationNationalMeasurementUnit < Sequel::Model
  set_primary_key [:goods_nomenclature_sid, :measurement_unit_code]

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid,
                                   foreign_key: :goods_nomenclature_sid
  many_to_one :national_measurement_unit, key: :measurement_unit_code,
                                          foreign_key: :measurement_unit_code

  validates do
    presence_of :measurement_unit_quantity_level
  end

  def level
    measurement_unit_quantity_level
  end
end
