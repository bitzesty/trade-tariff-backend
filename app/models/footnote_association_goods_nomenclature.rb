class FootnoteAssociationGoodsNomenclature < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  # TODO FIXME
  # belongs_to :footnote_type, foreign_key: :footnote_type
  belongs_to :footnote
end
