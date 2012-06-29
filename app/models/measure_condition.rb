class MeasureCondition < ActiveRecord::Base
  self.primary_key = :measure_condition_sid

  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :action, foreign_key: :action_code, class_name: 'MeasureAction'
  belongs_to :code, foreign_key: :condition_code, class_name: 'MeasureConditionCode'
  belongs_to :certificate, foreign_key: :certificate_code
  belongs_to :certificate_type, foreign_key: :certificate_type_code,
                                class_name: 'CertificateType'
end
