class FootnoteAssociationAdditionalCode < ActiveRecord::Base
  belongs_to :additional_code, foreign_key: :additional_code_sid
  belongs_to :footnote_type
  belongs_to :footnote
  belongs_to :additional_code_type
  belongs_to :additional_code, foreign_key: :additional_code
end
