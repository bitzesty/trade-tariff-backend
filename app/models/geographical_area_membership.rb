class GeographicalAreaMembership < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:geographical_area_sid,
                               :geographical_area_group_sid,
                               :validity_start_date]
  plugin :conformance_validator

  set_primary_key [:geographical_area_sid, :geographical_area_group_sid,
                         :validity_start_date]

end


