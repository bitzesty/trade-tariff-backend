class QuotaOrderNumberOrigin < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :geographical_area
end
