class RegulationReplacement < Sequel::Model
  set_primary_key  :replacing_regulation_id, :replacing_regulation_role,
                   :replaced_regulation_id, :replaced_regulation_role, :measure_type_id,
                   :geographical_area_id, :chapter_heading
end


