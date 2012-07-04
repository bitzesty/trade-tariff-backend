class DutyExpressionDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :duty_expression, foreign_key: :duty_expression_id
  belongs_to :language
end

# == Schema Information
#
# Table name: duty_expression_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  duty_expression_id     :string(255)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

