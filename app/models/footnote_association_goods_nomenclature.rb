class FootnoteAssociationGoodsNomenclature < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  # TODO FIXME
  # belongs_to :footnote_type, foreign_key: :footnote_type
  belongs_to :footnote
end
