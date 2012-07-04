class FootnoteAssociationGoodsNomenclature < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  # TODO FIXME
  # belongs_to :footnote_type, foreign_key: :footnote_type
  belongs_to :footnote
end

# == Schema Information
#
# Table name: footnote_association_goods_nomenclatures
#
#  record_code                :string(255)
#  subrecord_code             :string(255)
#  record_sequence_number     :string(255)
#  goods_nomenclature_sid     :string(255)
#  footnote_type              :string(255)
#  footnote_id                :string(255)
#  validity_start_date        :date
#  validity_end_date          :date
#  goods_nomenclature_item_id :string(255)
#  productline_suffix         :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#

