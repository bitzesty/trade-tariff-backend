class FootnoteAssociationAdditionalCode < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :footnote_type
  belongs_to :footnote
  belongs_to :additional_code_type
  # TODO find a better way to map
  belongs_to :ref_additional_code, foreign_key: :additional_code,
                                   class_name: 'AdditionalCode'
end
