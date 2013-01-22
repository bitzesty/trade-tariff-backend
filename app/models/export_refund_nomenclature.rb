class ExportRefundNomenclature < Sequel::Model
  plugin :time_machine, period_start_column: :export_refund_nomenclatures__validity_start_date,
                        period_end_column:   :export_refund_nomenclatures__validity_end_date

  set_dataset order(:export_refund_nomenclatures__goods_nomenclature_item_id.asc)

  set_primary_key :export_refund_nomenclature_sid

  many_to_many :export_refund_nomenclature_descriptions, join_table: :export_refund_nomenclature_description_periods,
                                                         left_primary_key: :export_refund_nomenclature_sid,
                                                         left_key: :export_refund_nomenclature_sid,
                                                         right_key: [:export_refund_nomenclature_description_period_sid, :export_refund_nomenclature_sid],
                                                         right_primary_key: [:export_refund_nomenclature_description_period_sid, :export_refund_nomenclature_sid] do |ds|
                                                           ds.with_actual(ExportRefundNomenclatureDescriptionPeriod)
                                                             .order(:export_refund_nomenclature_description_periods__validity_start_date.desc)
                                                         end

  def export_refund_nomenclature_description
    export_refund_nomenclature_descriptions.first
  end

  one_to_many :export_refund_nomenclature_indents, key: :export_refund_nomenclature_sid,
                                                   primary_key: :export_refund_nomenclature_sid do |ds|
    ds.with_actual(ExportRefundNomenclatureIndent)
      .order(:export_refund_nomenclature_indents__validity_start_date.desc)
  end

  def export_refund_nomenclature_indent
    export_refund_nomenclature_indents.first
  end

  delegate :description, to: :export_refund_nomenclature_description
  delegate :number_indents, to: :export_refund_nomenclature_indent

  def uptree
    @_uptree ||= [ancestors, self].flatten.compact
  end

  def ancestors
    ExportRefundNomenclature.select(:export_refund_nomenclatures.*)
      .eager(:export_refund_nomenclature_indents,
             :export_refund_nomenclature_descriptions)
      .join_table(:inner,
        ExportRefundNomenclatureIndent
                 .select(Sequel.as(:export_refund_nomenclatures__export_refund_nomenclature_sid, :gono_sid),
                         Sequel.as(:max.sql_function(:export_refund_nomenclatures__goods_nomenclature_item_id), :max_gono),
                         :export_refund_nomenclature_indents__number_export_refund_nomenclature_indents)
                 .with_actual(ExportRefundNomenclature)
                 .join(:export_refund_nomenclatures, export_refund_nomenclature_indents__export_refund_nomenclature_sid: :export_refund_nomenclatures__export_refund_nomenclature_sid)
                 .where("export_refund_nomenclature_indents.goods_nomenclature_item_id LIKE ?", heading_id)
                 .where("export_refund_nomenclature_indents.goods_nomenclature_item_id <= ?", goods_nomenclature_item_id)
                 .where("export_refund_nomenclature_indents.number_export_refund_nomenclature_indents < ?", export_refund_nomenclature_indent.number_export_refund_nomenclature_indents)
                 .order(:export_refund_nomenclature_indents__validity_start_date.desc,
                        :export_refund_nomenclature_indents__goods_nomenclature_item_id.desc)
                 .group(:export_refund_nomenclature_indents__export_refund_nomenclature_sid),
        { t1__gono_sid: :export_refund_nomenclatures__export_refund_nomenclature_sid,
          t1__max_gono: :export_refund_nomenclatures__goods_nomenclature_item_id })
      .order(:export_refund_nomenclatures__goods_nomenclature_item_id.desc)
      .all
      .group_by(&:number_indents)
      .map(&:last)
      .map(&:first)
      .reverse
      .sort_by(&:number_indents)
  end

  # TODO
  validates do
    # ERN5
    validity_dates
  end

  def additional_code
    "#{additional_code_type}#{export_refund_code}"
  end

  def heading_id
    "#{goods_nomenclature_item_id.first(4)}______"
  end
end


