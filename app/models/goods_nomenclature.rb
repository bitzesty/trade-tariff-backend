require 'sequel/plugins/time_machine'

class GoodsNomenclature < Sequel::Model
  plugin :time_machine

  set_dataset order(:goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_one :goods_nomenclature_indent, key: :goods_nomenclature_sid
  one_to_one :goods_nomenclature_description, dataset: -> {
    GoodsNomenclatureDescriptionPeriod.actual.first.goods_nomenclature_description_dataset
  }, eager_loader: ->(eo) {
    eo[:rows].each{|gono| gono.associations[:goods_nomenclature_description] = nil}
    id_map = eo[:id_map]
    GoodsNomenclatureDescriptionPeriod.actual
                                      .eager(:goods_nomenclature_description)
                                      .where(goods_nomenclature_sid: id_map.keys)
                                      .all do |period|
      if chapters = id_map[period.goods_nomenclature_sid]
        chapters.each do |chapter|
          chapter.associations[:goods_nomenclature_description] = period.goods_nomenclature_description
        end
      end
    end
  }

  delegate :number_indents, to: :goods_nomenclature_indent
  delegate :description, to: :goods_nomenclature_description

  alias :code :goods_nomenclature_item_id

  one_to_many :goods_nomenclature_origins, key: :goods_nomenclature_sid
  one_to_many :goods_nomenclature_successors, key: :goods_nomenclature_sid
  one_to_many :export_refund_nomenclatures, key: :goods_nomenclature_sid
  # one_to_many :footnote_association_goods_nomenclatures, foreign_key: :goods_nomenclature_sid
  # many_to_many :footnotes, through: :footnote_association_goods_nomenclatures
  # one_to_many :nomenclature_group_memberships, foreign_key: :goods_nomenclature_sid
  # many_to_many :goods_nomenclature_groups, through: :nomenclature_group_memberships

  def heading_id
    "#{goods_nomenclature_item_id.first(4)}______"
  end

  def chapter_id
    goods_nomenclature_item_id.first(2) + "0" * 8
  end
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

