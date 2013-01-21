require 'time_machine'

class GoodsNomenclature < Sequel::Model
  plugin :time_machine, period_start_column: :goods_nomenclatures__validity_start_date,
                        period_end_column:   :goods_nomenclatures__validity_end_date

  plugin :sti, class_determinator: ->(record) {
    gono_id = record[:goods_nomenclature_item_id].to_s

    if gono_id.ends_with?('00000000')
      'Chapter'
    elsif gono_id.ends_with?('000000') && gono_id.slice(2,2) != '00'
      'Heading'
    elsif !gono_id.ends_with?('000000')
      'Commodity'
    else
      'GoodsNomenclature'
    end
  }

  set_dataset order(:goods_nomenclatures__goods_nomenclature_item_id.asc)

  set_primary_key :goods_nomenclature_sid

  one_to_one :goods_nomenclature_indent, dataset: -> {
    actual(GoodsNomenclatureIndent).select_all(:goods_nomenclature_indents)
                                .where(goods_nomenclature_indents__goods_nomenclature_sid: goods_nomenclature_sid)
                                .order(:goods_nomenclature_indents__validity_start_date.desc)
                                .from_self(alias: :indents)
                                .group(:indents__goods_nomenclature_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|gono| gono.associations[:goods_nomenclature_indent] = nil}

    id_map = eo[:id_map]

  GoodsNomenclatureIndent.actual
                         .select_all(:goods_nomenclature_indents)
                         .where(goods_nomenclature_indents__goods_nomenclature_sid: id_map.keys)
                         .order(:goods_nomenclature_indents__validity_start_date.desc)
                         .from_self(alias: :indents)
                         .group(:indents__goods_nomenclature_sid)
                         .all do |indent|
      if gonos = id_map[indent.goods_nomenclature_sid]
        gonos.each do |gono|
          gono.associations[:goods_nomenclature_indent] = indent
        end
      end
    end
  end)

  one_to_one :goods_nomenclature_description, dataset: -> {
    GoodsNomenclatureDescription.select_all(:goods_nomenclature_descriptions)
                                .with_actual(GoodsNomenclatureDescriptionPeriod)
                                .join(:goods_nomenclature_description_periods, goods_nomenclature_description_periods__goods_nomenclature_description_period_sid: :goods_nomenclature_descriptions__goods_nomenclature_description_period_sid,
                                                                               goods_nomenclature_description_periods__goods_nomenclature_sid: :goods_nomenclature_descriptions__goods_nomenclature_sid)
                                .where(goods_nomenclature_descriptions__goods_nomenclature_sid: goods_nomenclature_sid)
                                .order(:goods_nomenclature_description_periods__validity_start_date.desc)
                                .from_self(alias: :descriptions)
                                .group(:descriptions__goods_nomenclature_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|gono| gono.associations[:goods_nomenclature_description] = nil}

    id_map = eo[:id_map]

    GoodsNomenclatureDescription.select_all(:goods_nomenclature_descriptions)
                                .with_actual(GoodsNomenclatureDescriptionPeriod)
                                .join(:goods_nomenclature_description_periods, goods_nomenclature_description_periods__goods_nomenclature_description_period_sid: :goods_nomenclature_descriptions__goods_nomenclature_description_period_sid,
                                                                               goods_nomenclature_description_periods__goods_nomenclature_sid: :goods_nomenclature_descriptions__goods_nomenclature_sid)
                                .where(goods_nomenclature_descriptions__goods_nomenclature_sid: id_map.keys)
                                .order(:goods_nomenclature_description_periods__validity_start_date.desc)
                                .from_self(alias: :descriptions)
                                .group(:descriptions__goods_nomenclature_sid)
                                .all do |description|
      if gonos = id_map[description.goods_nomenclature_sid]
        gonos.each do |gono|
          gono.associations[:goods_nomenclature_description] = description
        end
      end
    end
  end)

  one_to_one :footnote, key: {}, primary_key: {}, eager_loader_key: :goods_nomenclature_sid, dataset: -> {
    Footnote.with_actual(FootnoteAssociationGoodsNomenclature)
            .join(FootnoteAssociationGoodsNomenclature, footnote_association_goods_nomenclatures__footnote_type: :footnotes__footnote_type_id,
                                                        footnote_association_goods_nomenclatures__footnote_id: :footnotes__footnote_id)
            .where(footnote_association_goods_nomenclatures__goods_nomenclature_sid: goods_nomenclature_sid)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|gono| gono.associations[:footnote] = nil}

    id_map = eo[:id_map]

    Footnote.with_actual(FootnoteAssociationGoodsNomenclature)
            .join(FootnoteAssociationGoodsNomenclature, footnote_association_goods_nomenclatures__footnote_type: :footnotes__footnote_type_id,
                                                        footnote_association_goods_nomenclatures__footnote_id: :footnotes__footnote_id)
            .where(footnote_association_goods_nomenclatures__goods_nomenclature_sid: id_map.keys).all do |footnote|
      if gonos = id_map[footnote[:goods_nomenclature_sid]]
        gonos.each do |gono|
          gono.associations[:footnote] = footnote
        end
      end
    end
  end)

  delegate :number_indents, to: :goods_nomenclature_indent, allow_nil: true
  delegate :description, to: :goods_nomenclature_description, allow_nil: true

  one_to_one :goods_nomenclature_origin, key: [:goods_nomenclature_item_id,
                                               :productline_suffix],
                                         primary_key: [:goods_nomenclature_item_id,
                                                       :producline_suffix]

  one_to_many :goods_nomenclature_successors, key: [:absorbed_goods_nomenclature_item_id,
                                                    :absorbed_productline_suffix],
                                              primary_key: [:goods_nomenclature_item_id,
                                                            :producline_suffix]

  one_to_many :export_refund_nomenclatures, dataset: -> {
    actual(ExportRefundNomenclature).where(goods_nomenclature_sid: goods_nomenclature_sid)
  }

  one_to_many :measures, key: :goods_nomenclature_sid,
                         foreign_key: :goods_nomenclature_sid

  dataset_module do
    def declarable
      filter(producline_suffix: 80)
    end

    def non_hidden
      filter(~{goods_nomenclature_item_id: HiddenGoodsNomenclature.codes})
    end
  end

  # TODO
  validates do
    # NIG30 When a goods nomenclature is used in a goods measure then the validity period of the goods nomenclature must span the validity period of the goods measure.
    # associated :measures, ensure: :measures_are_valid
    # NIG4
    validity_dates
  end

  def id
    goods_nomenclature_sid
  end

  def heading_id
    "#{goods_nomenclature_item_id.first(4)}______"
  end

  def chapter_id
    goods_nomenclature_item_id.first(2) + "0" * 8
  end

  def code
    goods_nomenclature_item_id
  end

  def bti_url
    "http://ec.europa.eu/taxation_customs/dds2/ebti/ebti_consultation.jsp?Lang=en&nomenc=#{code}&Expand=true"
  end
end

require 'heading'
require 'chapter'
require 'commodity'
