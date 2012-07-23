class GeographicalAreaMembership < Sequel::Model
  plugin :time_machine

  set_primary_key [:geographical_area_sid, :geographical_area_group_sid,
                         :validity_start_date]

end


