class FootnoteAssociationGoodsNomenclature < ActiveRecord::Base
  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  belongs_to :footnote_type, foreign_key: :footnote_type
  belongs_to :footnote
  belongs_to :goods_nomenclature_item, foreign_key: :goods_nomenclature_item_sid
end
