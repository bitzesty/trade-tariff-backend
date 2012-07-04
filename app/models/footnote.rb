class Footnote < ActiveRecord::Base
  set_primary_keys :footnote_id

  belongs_to :footnote_type, primary_key: :footnote_type_id
  has_one  :footnote_description
  has_many :footnote_description_period
end

# == Schema Information
#
# Table name: footnotes
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  footnote_id            :string(255)
#  footnote_type_id       :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

