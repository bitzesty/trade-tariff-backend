class AdditionalCodeDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :additional_code_description_period, foreign_key: :additional_code_description_period_sid
  belongs_to :language
  belongs_to :code_type, foreign_key: :additional_code_type_id,
                         class_name: 'AdditionalCodeType'
  belongs_to :code, foreign_key: :additional_code_sid,
                    class_name: 'AdditionalCode'
end
