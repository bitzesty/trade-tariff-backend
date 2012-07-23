class FootnoteAssociationGoodsNomenclature < Sequel::Model
  set_primary_key  [:footnote_id, :footnote_type, :goods_nomenclature_sid,
                         :validity_start_date]

  # belongs_to :goods_nomenclature, primary_key: :goods_nomenclature_sid
  # belongs_to :footnote, primary_key: :footnote_id
end


