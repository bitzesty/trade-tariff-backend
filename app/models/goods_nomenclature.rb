require 'time_machine'

class GoodsNomenclature < Sequel::Model
  plugin :time_machine, period_start_column: Sequel.qualify(:goods_nomenclatures, :validity_start_date),
                        period_end_column:   Sequel.qualify(:goods_nomenclatures, :validity_end_date)

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

  one_to_many :goods_nomenclature_indents, key: :goods_nomenclature_sid,
                                           primary_key: :goods_nomenclature_sid do |ds|
    ds.with_actual(GoodsNomenclatureIndent, self)
      .order(:goods_nomenclature_indents__validity_start_date.desc)
  end

  def goods_nomenclature_indent
    goods_nomenclature_indents.first
  end

  many_to_many :goods_nomenclature_descriptions, join_table: :goods_nomenclature_description_periods,
                                                 left_primary_key: :goods_nomenclature_sid,
                                                 left_key: :goods_nomenclature_sid,
                                                 right_key: [:goods_nomenclature_description_period_sid, :goods_nomenclature_sid],
                                                 right_primary_key: [:goods_nomenclature_description_period_sid, :goods_nomenclature_sid] do |ds|
    ds.with_actual(GoodsNomenclatureDescriptionPeriod, self)
      .order(:goods_nomenclature_description_periods__validity_start_date.desc)
  end

  def goods_nomenclature_description
    goods_nomenclature_descriptions.first
  end

  many_to_many :footnotes, join_table: :footnote_association_goods_nomenclatures,
                           left_primary_key: :goods_nomenclature_sid,
                           left_key: :goods_nomenclature_sid,
                           right_key: [:footnote_type, :footnote_id],
                           right_primary_key: [:footnote_type_id, :footnote_id] do |ds|
    ds.with_actual(FootnoteAssociationGoodsNomenclature)
  end

  def footnote
    footnotes.first
  end

  one_to_one :national_measurement_unit_set, key: :cmdty_code,
                                             primary_key: :goods_nomenclature_item_id do |ds|
    ds.with_actual(Chief::Comm)
  end

  delegate :national_measurement_unit_set_units, to: :national_measurement_unit_set, allow_nil: true

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

  one_to_many :export_refund_nomenclatures, key: :goods_nomenclature_sid,
                                            primary_key: :goods_nomenclature_sid do |ds|
    ds.with_actual(ExportRefundNomenclature)
  end

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
