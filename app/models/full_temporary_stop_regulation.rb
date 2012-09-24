class FullTemporaryStopRegulation < Sequel::Model
  plugin :time_machine

  set_primary_key [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role]
end


