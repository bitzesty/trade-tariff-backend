class Footnote < ActiveRecord::Base
  set_primary_keys :footnote_id, :footnote_type_id

  has_many   :footnote_description_periods, foreign_key: [:footnote_id,
                                                          :footnote_type_id]
  has_many   :footnote_descriptions, through: :footnote_description_periods
  has_many   :footnote_association_erns, foreign_key: :footnote_id
  has_many   :export_refund_nomenclatures, through: :footnote_association_erns
  has_many   :footnote_association_measures, foreign_key: :footnote_id
  has_many   :measures, through: :footnote_association_measures, foreign_key: :measure_sid
  has_many   :footnote_association_meursing_heading, foreign_key: :footnote_id
  has_many   :meursing_table_plans, through: :footnote_association_meursing_headings
  has_many   :footnote_association_goods_nomenclatures, foreign_key: :footnote_id
  has_many   :goods_nomenclatures, through: :footnote_association_goods_nomenclatures

  belongs_to :footnote_type, primary_key: :footnote_type_id
end

# == Schema Information
#
# Table name: footnotes
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  footnote_id            :string(255)
#  footnote_type_id       :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

