class MeursingAdditionalCode < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :table_cell_component, foreign_key: :meursing_additional_code_sid,
                                 class_name: 'MeursingTableCellComponent'
end
