class MeursingAdditionalCode < ActiveRecord::Base
  self.primary_key = :meursing_additional_code_sid

  has_one :table_cell_component, foreign_key: :meursing_additional_code_sid
end
