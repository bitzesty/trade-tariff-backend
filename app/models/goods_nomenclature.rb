class GoodsNomenclature < ActiveRecord::Base
  self.primary_keys =  :goods_nomenclature_sid

  has_many :goods_nomenclature_description_periods, foreign_key: :goods_nomenclature_sid
  has_many :goods_nomenclature_descriptions, through: :goods_nomenclature_description_periods
  has_one  :goods_nomenclature_indent, foreign_key: :goods_nomenclature_sid
  has_many :goods_nomenclature_origins, foreign_key: :goods_nomenclature_sid
  has_many :goods_nomenclature_successors, foreign_key: :goods_nomenclature_sid
  has_many :export_refund_nomenclatures, foreign_key: :goods_nomenclature_sid
  has_many :footnote_association_goods_nomenclatures, foreign_key: :goods_nomenclature_sid
  has_many :footnotes, through: :footnote_association_goods_nomenclatures
  has_many :nomenclature_group_memberships, foreign_key: :goods_nomenclature_sid
  has_many :goods_nomenclature_groups, through: :nomenclature_group_memberships
  has_many :measures, foreign_key: :goods_nomenclature_sid
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

