attributes :footnote_id,
           :footnote_type_id,
           :validity_start_date,
           :validity_end_date

node(:description) { |footnote| footnote.formatted_description }
