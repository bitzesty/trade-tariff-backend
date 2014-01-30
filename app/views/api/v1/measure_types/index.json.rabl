collection @measure_types

attributes :validity_start_date,
           :validity_end_date

node(:id) { |measure_type| measure_type.measure_type_id }
node(:description) { |measure_type| measure_type.description }
