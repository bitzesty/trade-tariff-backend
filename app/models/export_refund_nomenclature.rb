class ExportRefundNomenclature < Sequel::Model
  set_primary_key :export_refund_nomenclature_sid

  one_to_many :export_refund_nomenclature_description_periods, key: :export_refund_nomenclature_sid
  #has_many :export_refund_nomenclature_descriptions, through: :export_refund_nomenclature_description_periods
  #has_many :export_refund_nomenclature_indents, foreign_key: :export_refund_nomenclature_sid
  #has_many :footnote_association_erns, foreign_key: :export_refund_nomenclature_sid
  #has_many :footnotes, through: :footnote_association_erns

  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid

  # TODO
  def validate
    super
    # ERN5
    validates_start_date
  end
end


