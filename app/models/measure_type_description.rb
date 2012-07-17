class MeasureTypeDescription < Sequel::Model
  set_primary_key :measure_type_id

  def to_s
    description
  end
end

# == Schema Information
#
# Table name: measure_type_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  measure_type_id        :integer(4)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

