collection @footnotes

attributes :footnote_id,
           :footnote_type_id,
           :validity_start_date,
           :validity_end_date

node(:id) { |footnote| "#{footnote.footnote_type_id}#{footnote.footnote_id}" }
node(:description) { |footnote| footnote.formatted_description }
