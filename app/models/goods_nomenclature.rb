class GoodsNomenclature < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :goods_nomenclature_description, foreign_key: :goods_nomenclature_sid
  has_many :goods_nomenclature_description_periods, foreign_key: :goods_nomenclature_sid
  has_one :goods_nomenclature_indent, foreign_key: :goods_nomenclature_sid

  has_one :goods_nomenclature_successor, foreign_key: :goods_nomenclature_sid
  has_one :goods_nomenclature_origin, foreign_key: :goods_nomenclature_sid

  has_one :export_refund_nomenclature, foreign_key: :goods_nomenclature_sid
  has_many :footnote_association_goods_nomenclatures, foreign_key: :goods_nomenclature_sid
  has_many :footnotes, through: :footnote_association_goods_nomenclatures
end

# == Schema Information
#
# Table name: goods_nomenclatures
#
#  record_code                :string(255)
#  subrecord_code             :string(255)
#  record_sequence_number     :string(255)
#  goods_nomenclature_sid     :integer(4)
#  goods_nomenclature_item_id :string(255)
#  producline_suffix          :string(255)
#  validity_start_date        :date
#  validity_end_date          :date
#  statistical_indicator      :integer(4)
#  created_at                 :datetime
#  updated_at                 :datetime
#

