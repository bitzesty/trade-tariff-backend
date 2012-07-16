require 'dateable'

class GoodsNomenclature < Sequel::Model
  # include Model::Dateable
  #

  set_primary_key :goods_nomenclature_sid
  # self.primary_keys =  :goods_nomenclature_sid

  one_to_one :goods_nomenclature_indent, key: :goods_nomenclature_sid
  # has_one  :goods_nomenclature_indent, foreign_key: :goods_nomenclature_sid
  # has_many :goods_nomenclature_description_periods, foreign_key: :goods_nomenclature_sid
  # has_many :goods_nomenclature_descriptions, through: :goods_nomenclature_description_periods
  # has_many :goods_nomenclature_origins, foreign_key: :goods_nomenclature_sid
  # has_many :derived_goods_nomenclatures, through: :goods_nomenclature_origins,
  #                                        source: :derived_goods_nomenclature,
  #                                        foreign_key: :goods_nomenclature_sid
  # has_many :goods_nomenclature_successors, foreign_key: :goods_nomenclature_sid
  # has_many :absorbed_goods_nomenclatures, through: :goods_nomenclature_successors,
  #                                         source: :absorbed_goods_nomenclature,
  #                                        foreign_key: :goods_nomenclature_sid
  # has_many :export_refund_nomenclatures, foreign_key: :goods_nomenclature_sid
  # has_many :footnote_association_goods_nomenclatures, foreign_key: :goods_nomenclature_sid
  # has_many :footnotes, through: :footnote_association_goods_nomenclatures
  # has_many :nomenclature_group_memberships, foreign_key: :goods_nomenclature_sid
  # has_many :goods_nomenclature_groups, through: :nomenclature_group_memberships

  # scope :with_item_id, ->(item_id) { where{goods_nomenclature_item_id.eq item_id} }
  # scope :with_indent, includes(:goods_nomenclature_indent)
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

