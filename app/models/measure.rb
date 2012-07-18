require 'time_machine'

class Measure < Sequel::Model
  plugin :time_machine

  set_primary_key :measure_sid

  # rename to Declarable
  many_to_one :goods_nomenclature, key: :goods_nomenclature_sid,
                                   foreign_key: :goods_nomenclature_sid
  many_to_one :measure_type, key: {}, dataset: -> {
    MeasureType.actual.where(measure_type_id: self[:measure_type])
  }
  one_to_many :measure_conditions, key: :measure_sid
  one_to_one :geographical_area, dataset: -> {
    GeographicalArea.actual.where(geographical_area_sid: geographical_area_sid)
  }
  many_to_many :excluded_geographical_areas, join_table: :measure_excluded_geographical_areas,
                                             left_key: :measure_sid,
                                             left_primary_key: :measure_sid,
                                             right_key: :excluded_geographical_area,
                                             right_primary_key: :geographical_area_id,
                                             class_name: 'GeographicalArea'
  many_to_many :footnotes, dataset: -> {
    Footnote.actual
            .join(:footnote_association_measures, footnote_id: :footnote_id, footnote_type_id: :footnote_type_id)
            .where("footnote_association_measures.measure_sid = ?", measure_sid)
  }
  one_to_many :measure_components, key: :measure_sid,
                                   primary_key: :measure_sid
  one_to_one :additional_code, key: :additional_code_sid

  delegate :measure_type_description, to: :measure_type

  dataset_module do
    # Measures are relevant if the the measure generating regulation
    # is actual at given point in time
    def relevant
      base_regulation_ids = BaseRegulation.actual
                                          .select(:base_regulation_id)

      modification_regulation_ids = ModificationRegulation.actual
                                                          .select(:modification_regulation_id)

      filter({measure_generating_regulation_id: base_regulation_ids} |
             {measure_generating_regulation_id: modification_regulation_ids})
    end
  end

  def generating_regulation_present?
    measure_generating_regulation_id.present? && measure_generating_regulation_role.present?
  end

  def generating_regulation_code
    "#{measure_generating_regulation_id.first}#{measure_generating_regulation_id[3..6]}/#{measure_generating_regulation_id[1..2]}"
  end

  def generating_regulation_url
    code = "#{measure_generating_regulation_id[1..2]}#{measure_generating_regulation_id.first}#{measure_generating_regulation_id[3..6]}"
    "http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:320#{code}:en:HTML"
  end

  def origin
    "eu"
  end

  # has_many :footnote_association_measures, foreign_key: :measure_sid
  # has_many :footnotes, through: :footnote_association_measures, foreign_key: :footnote_id
  # has_many :measure_components, foreign_key: :measure_sid
  # has_many :measure_conditions, foreign_key: :measure_sid
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

