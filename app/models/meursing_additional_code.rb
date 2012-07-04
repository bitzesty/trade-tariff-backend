class MeursingAdditionalCode < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :table_cell_component, foreign_key: :meursing_additional_code_sid,
                                 class_name: 'MeursingTableCellComponent'
end

# == Schema Information
#
# Table name: meursing_additional_codes
#
#  record_code                  :string(255)
#  subrecord_code               :string(255)
#  record_sequence_number       :string(255)
#  meursing_additional_code_sid :integer(4)
#  additional_code              :integer(4)
#  validity_start_date          :date
#  created_at                   :datetime
#  updated_at                   :datetime
#

