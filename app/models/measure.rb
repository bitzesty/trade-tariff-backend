class Measure < Sequel::Model
  set_primary_key :measure_sid

  # rename to Declarable
  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid, foreign_key: :goods_nomenclature_sid

  dataset_module do
    # Measures are relevant if the the measure generating regulation is still effective
    def relevant_on(date)
      base_regulation_ids = BaseRegulation.valid_on(date)
                                          .select(:base_regulation_id)

      modification_regulation_ids = ModificationRegulation.valid_on(date)
                                                          .select(:modification_regulation_id)

      filter({measure_generating_regulation_id:  base_regulation_ids} |
             {measure_generating_regulation_id: modification_regulation_ids}).
      where('measures.validity_start_date <= ? AND (measures.validity_end_date >= ? OR measures.validity_end_date IS NULL)', date, date)
    end
  end

  # has_many :footnote_association_measures, foreign_key: :measure_sid
  # has_many :footnotes, through: :footnote_association_measures, foreign_key: :footnote_id
  # has_many :measure_components, foreign_key: :measure_sid
  # has_many :measure_conditions, foreign_key: :measure_sid
  # has_many :measure_excluded_geographical_areas, foreign_key: :measure_sid,
  #                                                source: :excluded_geographical_area
  # has_many :excluded_geographical_areas, through: :measure_excluded_geographical_areas,
  #                                        source: :ref_excluded_geographical_area
  # belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  # belongs_to :justification_regulation, foreign_key: [:justification_regulation_role,
  #                                                     :justification_regulation_id],
  #                                       class_name: 'BaseRegulation'
  # belongs_to :base_regulation, primary_key: [:base_regulation_id,
  #                                            :base_regulation_role],
  #                               foreign_key: [:measure_generating_regulation_id,
  #                                             :measure_generating_regulation_role],
  #                               class_name: 'BaseRegulation'
  # belongs_to :modification_regulation, primary_key: [:modification_regulation_id,
  #                                                    :modification_regulation_role],
  #                                      foreign_key: [:measure_generating_regulation_id,
  #                                                    :measure_generating_regulation_role],
  #                                      class_name: 'ModificationRegulation'
  # has_many :measure_partial_temporary_stops, foreign_key: :measure_sid
  # has_many :partial_temporary_stopped_regulations, through: :measure_partial_temporary_stops,
  #                                                  source: :stopped_regulation
  # has_many :abrogated_regulations, through: :measure_partial_temporary_stops,
  #                                  source: :abrogated_regulation
  # # TODO come up with better naming scheme
  # belongs_to :ref_measure_type, foreign_key: :measure_type,
  #                               class_name: 'MeasureType'
  # belongs_to :ref_additional_code, foreign_key: :additional_code_sid,
  #                                  class_name: 'AdditionalCode'
  # belongs_to :ref_geographical_area, foreign_key: :geographical_area_sid,
  #                                    class_name: 'GeographicalArea'

  # delegate :description, to: :ref_measure_type, prefix: :measure_type
  # delegate :duty_rate, to: :

end

# == Schema Information
#
# Table name: measures
#
#  record_code                        :string(255)
#  subrecord_code                     :string(255)
#  record_sequence_number             :string(255)
#  measure_sid                        :integer(4)
#  measure_type                       :integer(4)
#  geographical_area                  :string(255)
#  goods_nomenclature_item_id         :string(255)
#  validity_start_date                :date
#  validity_end_date                  :date
#  measure_generating_regulation_role :integer(4)
#  measure_generating_regulation_id   :string(255)
#  justification_regulation_role      :integer(4)
#  justification_regulation_id        :string(255)
#  stopped_flag                       :boolean(1)
#  geographical_area_sid              :integer(4)
#  goods_nomenclature_sid             :integer(4)
#  ordernumber                        :string(255)
#  additional_code_type               :integer(4)
#  additional_code                    :string(255)
#  additional_code_sid                :string(255)
#  reduction_indicator                :integer(4)
#  export_refund_nomenclature_sid     :string(255)
#  created_at                         :datetime
#  updated_at                         :datetime
#

