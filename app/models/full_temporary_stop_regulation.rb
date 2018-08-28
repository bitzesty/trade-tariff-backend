class FullTemporaryStopRegulation < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:full_temporary_stop_regulation_id,
                               :full_temporary_stop_regulation_role]
  plugin :conformance_validator

  set_primary_key [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role]

  one_to_one :complete_abrogation_regulation, key: [:complete_abrogation_regulation_id,
                                                    :complete_abrogation_regulation_role]

  def regulation_id
    full_temporary_stop_regulation_id
  end

  def effective_start_date
    validity_start_date.to_date
  end
end


