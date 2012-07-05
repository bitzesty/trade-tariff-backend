class MeursingAdditionalCode < ActiveRecord::Base
  set_primary_keys :meursing_additional_code_sid

  has_many :meursing_table_cell_components, foreign_key: :meursing_additional_code_sid
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

