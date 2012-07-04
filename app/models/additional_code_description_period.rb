class AdditionalCodeDescriptionPeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :additional_code_description_period_sid,
                        class_name: 'AdditionalCodeDescription'
  belongs_to :code, foreign_key: :additional_code_sid,
                    class_name: 'AdditionalCode'
  belongs_to :code_type, foreign_key: :additional_code_type_id,
                         class_name: 'AdditionalCodeType'
end
