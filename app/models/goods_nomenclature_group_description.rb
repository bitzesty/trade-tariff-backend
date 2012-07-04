class GoodsNomenclatureGroupDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :goods_nomenclature_group, foreign_key: [:goods_nomenclature_group_type, :goods_nomenclature_group_id]
  belongs_to :language
end

# == Schema Information
#
# Table name: goods_nomenclature_group_descriptions
#
#  record_code                   :string(255)
#  subrecord_code                :string(255)
#  record_sequence_number        :string(255)
#  goods_nomenclature_group_type :string(255)
#  goods_nomenclature_group_id   :string(255)
#  language_id                   :string(255)
#  description                   :text
#  created_at                    :datetime
#  updated_at                    :datetime
#

