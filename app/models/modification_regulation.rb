class ModificationRegulation < Sequel::Model
  plugin :time_machine, period_start_column: :modification_regulations__validity_start_date,
                        period_end_column: :effective_end_date

  set_primary_key [:modification_regulation_id, :modification_regulation_role]

  # TODO
  def validate
    super
    # ROIMM5
    validates_start_date
  end

end


