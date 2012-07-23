class Footnote < Sequel::Model
  plugin :time_machine

  set_primary_key :footnote_id, :footnote_type_id

  one_to_one :footnote_description, primary_key: {}, key: {}, dataset: -> {
    actual(FootnoteDescriptionPeriod).where(footnote_id: footnote_id,
                                            footnote_type_id: footnote_type_id)
                                     .order(:validity_start_date.desc)
                                     .first
                                     .footnote_description_dataset
  }

  def code
    "#{footnote_type_id}#{footnote_id}"
  end

  # has_many   :footnote_description_periods, foreign_key: [:footnote_id,
  #                                                         :footnote_type_id]
  # has_many   :footnote_descriptions, through: :footnote_description_periods
  # has_many   :footnote_association_erns, foreign_key: :footnote_id
  # has_many   :export_refund_nomenclatures, through: :footnote_association_erns
  # has_many   :footnote_association_measures, foreign_key: :footnote_id
  # has_many   :measures, through: :footnote_association_measures, foreign_key: :measure_sid
  # has_many   :footnote_association_meursing_headings, foreign_key: :footnote_id
  # has_many   :meursing_table_plans, through: :footnote_association_meursing_headings
  # has_many   :footnote_association_goods_nomenclatures, foreign_key: :footnote_id
  # has_many   :goods_nomenclatures, through: :footnote_association_goods_nomenclatures
  # has_many   :footnote_association_additional_codes, foreign_key: [:footnote_id, :footnote_type_id]
  # has_many   :additional_codes, through: :footnote_association_additional_codes,
  #                               source: :ref_additional_code
  # has_many   :additional_code_types, through: :footnote_association_additional_codes,
  #                                    source: :additional_code_type

  # belongs_to :footnote_type, primary_key: :footnote_type_id
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

