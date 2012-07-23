require 'time_machine'

class GoodsNomenclature < Sequel::Model
  plugin :time_machine

  set_dataset order(:goods_nomenclatures__goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_one :goods_nomenclature_indent, key: :goods_nomenclature_sid
  one_to_one :goods_nomenclature_description, dataset: -> {
    GoodsNomenclatureDescription.with_actual(GoodsNomenclatureDescriptionPeriod)
                                .join(:goods_nomenclature_description_periods, goods_nomenclature_description_periods__goods_nomenclature_description_period_sid: :goods_nomenclature_descriptions__goods_nomenclature_description_period_sid,
                                                                               goods_nomenclature_description_periods__goods_nomenclature_sid: :goods_nomenclature_descriptions__goods_nomenclature_sid)
                                .where(goods_nomenclature_descriptions__goods_nomenclature_sid: goods_nomenclature_sid)
  }

  delegate :number_indents, to: :goods_nomenclature_indent
  delegate :description, to: :goods_nomenclature_description

  one_to_one :goods_nomenclature_origin, key: [:goods_nomenclature_item_id,
                                               :productline_suffix],
                                         primary_key: [:goods_nomenclature_item_id,
                                                       :producline_suffix]

  one_to_many :goods_nomenclature_successors, key: [:absorbed_goods_nomenclature_item_id,
                                                    :absorbed_productline_suffix],
                                              primary_key: [:goods_nomenclature_item_id,
                                                            :producline_suffix]
  one_to_many :export_refund_nomenclatures, key: :goods_nomenclature_sid

  def heading_id
    "#{goods_nomenclature_item_id.first(4)}______"
  end

  def chapter_id
    goods_nomenclature_item_id.first(2) + "0" * 8
  end

  def code
    goods_nomenclature_item_id
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

