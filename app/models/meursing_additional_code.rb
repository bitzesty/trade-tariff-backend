class MeursingAdditionalCode < Sequel::Model
  set_primary_key  :meursing_additional_code_sid

  # has_many :meursing_table_cell_components, foreign_key: :meursing_additional_code_sid
end


