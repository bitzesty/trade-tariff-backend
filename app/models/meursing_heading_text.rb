class MeursingHeadingText < ActiveRecord::Base
  belongs_to :meursing_table_plan
  belongs_to :language
end
