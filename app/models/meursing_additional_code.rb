class MeursingAdditionalCode < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_one :table_cell_component, foreign_key: :meursing_additional_code_sid,
                                 class_name: 'MeursingTableCellComponent'
end
