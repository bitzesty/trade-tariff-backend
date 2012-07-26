class ModificationRegulation < Sequel::Model
  plugin :time_machine, period_start_column: :modification_regulations__validity_start_date,
                        period_end_column: :modification_regulations__effective_end_date

  set_primary_key [:modification_regulation_id, :modification_regulation_role]


  # scope :effective_on, ->(date) { where{(validity_start_date.lte date) &
  #                                   ((effective_end_date.gte date) |
  #                                    (effective_end_date.eq nil)
  #                                   )}
  #                               }
end


