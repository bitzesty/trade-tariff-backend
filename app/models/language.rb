class Language < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :language_descriptions
  has_many :additional_code_descriptions
  has_many :additional_code_type_descriptions
  has_many :certificate_descriptions
  has_many :certificate_type_descriptions
  has_many :duty_expression_descriptions
  has_many :export_refund_nomenclature_descriptions
  has_many :footnote_descriptions
  has_many :footnote_type_descriptions
  has_many :geographical_area_descriptions
  has_many :geographical_area_group_descriptions, foreign_key: :parent_geographical_area_group_sid,
                                                  class_name: 'GeographicalArea'
  has_many :language_descriptions
  has_many :measure_action_descriptions
  has_many :measure_condition_code_descriptions
  has_many :measure_type_descriptions
  has_many :measure_type_series_descriptions
  has_many :measurement_unit_descriptions
  has_many :measurement_unit_qualifier_descriptions
  has_many :meursing_heading_texts
  has_many :monetary_unit_descriptions
  has_many :regulation_group_descriptions
  has_many :regulation_role_type_descriptions
  has_many :transmission_comments
  has_many :goods_nomenclature_descriptions
  has_many :goods_nomenclature_group_descriptions
end

# == Schema Information
#
# Table name: languages
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  language_id            :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

