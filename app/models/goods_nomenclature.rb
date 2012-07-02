class GoodsNomenclature < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_one :goods_nomenclature_description, foreign_key: :goods_nomenclature_sid
  has_many :goods_nomenclature_description_periods, foreign_key: :goods_nomenclature_sid
  has_one :goods_nomenclature_indent, foreign_key: :goods_nomenclature_sid

  has_one :goods_nomenclature_successor, foreign_key: :goods_nomenclature_sid
  has_one :goods_nomenclature_origin, foreign_key: :goods_nomenclature_sid

  has_one :export_refund_nomenclature, foreign_key: :goods_nomenclature_sid
  has_many :footnote_association_goods_nomenclatures, foreign_key: :goods_nomenclature_sid
  has_many :footnotes, through: :footnote_association_goods_nomenclatures
end
