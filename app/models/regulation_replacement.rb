class RegulationReplacement < ActiveRecord::Base
  set_primary_keys :replacing_regulation_id, :replacing_regulation_role,
                   :replaced_regulation_id, :replaced_regulation_role

  belongs_to :replacing_regulation, foreign_key: [:replacing_regulation_role,
                                                  :replacing_regulation_id],
                                    class_name: 'BaseRegulation'
  belongs_to :replaced_regulation, foreign_key: [:replaced_regulation_role,
                                                 :replaced_regulation_id],
                                    class_name: 'BaseRegulation'
  belongs_to :measure_type

end

# == Schema Information
#
# Table name: regulation_replacements
#
#  record_code               :string(255)
#  subrecord_code            :string(255)
#  record_sequence_number    :string(255)
#  geographical_area_id      :string(255)
#  chapter_heading           :string(255)
#  replacing_regulation_role :integer(4)
#  replacing_regulation_id   :string(255)
#  replaced_regulation_role  :integer(4)
#  replaced_regulation_id    :string(255)
#  measure_type_id           :integer(4)
#  created_at                :datetime
#  updated_at                :datetime
#

