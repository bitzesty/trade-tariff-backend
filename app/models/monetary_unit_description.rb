class MonetaryUnitDescription < ActiveRecord::Base
  self.primary_keys =  :monetary_unit_code

  belongs_to :monetary_unit, foreign_key: :monetary_unit_code
  belongs_to :language
end

# == Schema Information
#
# Table name: monetary_unit_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  monetary_unit_code     :string(255)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

