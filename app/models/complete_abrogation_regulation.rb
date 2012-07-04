class CompleteAbrogationRegulation < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :modification_regulations
end
