class FootnoteAssociationGoodsNomenclature < ActiveRecord::Base
  self.primary_keys =  :footnote_id, :goods_nomenclature_sid

  belongs_to :goods_nomenclature, primary_key: :goods_nomenclature_sid
  belongs_to :footnote, primary_key: :footnote_id
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

