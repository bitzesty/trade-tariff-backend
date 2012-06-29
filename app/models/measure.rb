class Measure < ActiveRecord::Base
  self.primary_key = :measure_sid

  has_many :measure_components, foreign_key: :measure_sid
  has_many :excluded_geographical_areas, class_name: 'GeographicalArea'
  belongs_to :duty_expression
  belongs_to :goods_nomenclature, foreign_key: :goods_nomenclature_sid
  belongs_to :justification_regulation, foreign_key: [:justification_regulation_role,
                                                      :justification_regulation_id],
                                        class_name: 'BaseRegulation'
  belongs_to :measure_generating_regulation, foreign_key: [:measure_generating_regulation_role,
                                                           :measure_generating_regulation_id],
                                             class_name: 'BaseRegulation'
end
