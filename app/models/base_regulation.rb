class BaseRegulation < Sequel::Model
  plugin :time_machine, period_start_column: :base_regulations__validity_start_date,
                        period_end_column: :effective_end_date

  set_primary_key [:base_regulation_id, :base_regulation_role]


  # TODO
  def validate
    super
    # ROIMB3
    validates_start_date
  end
end


