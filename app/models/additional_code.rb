class AdditionalCode < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :description_periods, foreign_key: :additional_code_sid,
                                 class_name: 'AdditionalCodeDescriptionPeriod'
  has_many :measures, foreign_key: :additional_code
  has_many :additional_code_descriptions, foreign_key: :additional_code_sid
  has_many :additional_code_description_periods, foreign_key: :additional_code_sid
  has_many :footnote_association_additional_codes, foreign_key: :additional_code

  belongs_to :additional_code_type
end
