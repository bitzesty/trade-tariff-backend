TradeTariffBackend::DataMigrator.migration do
  name 'Delete 05044 footnote for 7304293080 commodity'

  up do
    applicable do
      FootnoteAssociationGoodsNomenclature::Operation.where(
        goods_nomenclature_sid: 86621,
        footnote_id: '004',
        footnote_type: '05',
        goods_nomenclature_item_id: '7304293080',
        operation: 'D'
      ).none?
    end

    apply do
      FootnoteAssociationGoodsNomenclature::Operation.create(
        goods_nomenclature_sid: 86621,
        footnote_id: '004',
        footnote_type: '05',
        goods_nomenclature_item_id: '7304293080',
        productline_suffix: '80',
        national: true,
        validity_start_date: '2020-09-20 00:00:00.000000',
        validity_end_date: nil,
        operation: 'D'
      )
    end
  end

  down do
    applicable do
      FootnoteAssociationGoodsNomenclature::Operation.where(
        goods_nomenclature_sid: 86621,
        footnote_id: '004',
        footnote_type: '05',
        goods_nomenclature_item_id: '7304293080',
        operation: 'D'
      ).any?
    end

    apply do
      FootnoteAssociationGoodsNomenclature::Operation.where(
        goods_nomenclature_sid: 86621,
        footnote_id: '004',
        footnote_type: '05',
        goods_nomenclature_item_id: '7304293080',
        operation: 'D'
      ).delete
    end
  end
end
