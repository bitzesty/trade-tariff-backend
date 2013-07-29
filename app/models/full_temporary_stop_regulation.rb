class FullTemporaryStopRegulation < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:full_temporary_stop_regulation_id,
                               :full_temporary_stop_regulation_role]
  plugin :conformance_validator

  set_primary_key [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role]

  def regulation_id
    full_temporary_stop_regulation_id
  end

  def effective_end_date
    effective_enddate.to_date if effective_enddate.present?
  end

  def effective_start_date
    validity_start_date.to_date
  end
end


