class FootnoteAssociationMeursingHeading < ActiveRecord::Base
  belongs_to :meursing_table_plan
  belongs_to :footnote_type, foreign_key: :footnote_type
  belongs_to :footnote
end
