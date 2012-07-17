require 'sequel/plugins/time_machine'

class GoodsNomenclature < Sequel::Model
  plugin :time_machine

  set_dataset order(:goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_one :goods_nomenclature_indent, key: :goods_nomenclature_sid
  one_to_many :goods_nomenclature_description_periods, key: :goods_nomenclature_sid
  many_to_many :goods_nomenclature_descriptions, left_key: :goods_nomenclature_sid,
                                                 right_key: :goods_nomenclature_description_period_sid,
                                                 right_primary_key: :goods_nomenclature_description_period_sid,
                                                 join_table: :goods_nomenclature_description_periods

  dataset_module do
    def valid_on(date)
      where('goods_nomenclatures.validity_start_date <= ? AND (goods_nomenclatures.validity_end_date >= ? OR goods_nomenclatures.validity_end_date IS NULL)', date, date)
    end

    def valid_between(start_date, end_date)
      filter('goods_nomenclatures.validity_start_date <= ? AND (goods_nomenclatures.validity_end_date >= ? OR goods_nomenclatures.validity_end_date IS NULL)', start_date, end_date)
    end

    def valid_inside(start_date, end_date)
      filter('goods_nomenclatures.validity_start_date >= ? AND (goods_nomenclatures.validity_end_date <= ? OR goods_nomenclatures.validity_end_date IS NULL)', start_date, end_date)
    end
  end

  delegate :number_indents, to: :goods_nomenclature_indent

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

