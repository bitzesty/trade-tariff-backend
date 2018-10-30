attributes :validity_start_date,
           :validity_end_date,
           :officialjournal_number,
           :officialjournal_page,
           :published_date

node(:regulation_code) { |regulation| regulation_code(regulation) }
node(:regulation_url) { |regulation| regulation_url(regulation) }
