Sequel.migration do
  up do
    run "UPDATE footnote_descriptions SET description='Contact Details for lead Government Department are as follows: <P>Fruit and Vegetables conformity controls </P> <P>Horticultural Marketing Inspectorate ( HMI) </P><P>Rural Payments Agency </P><P> Office SCF3 South Core Produce Hall </P><P> Western International Market </P><P>Hayes Road </P><P>Southall</P><P>UB2 5XJ </P><P>Telephone 0845 6073224 </P><P>Email: <a href=\"Peachenquiries@rpa.gsi.gov.uk\">Peachenquiries@rpa.gsi.gov.uk</a>' WHERE footnote_description_period_sid=-167"
    run "UPDATE footnote_descriptions SET description='Contact Details for lead Government Department are as follows: <P>Fruit and Vegetables conformity controls </P> <P>Horticultural Marketing Inspectorate ( HMI) </P><P>Rural Payments Agency </P><P> Office SCF3 South Core Produce Hall </P><P> Western International Market </P><P>Hayes Road </P><P>Southall</P><P>UB2 5XJ </P><P>Telephone 0845 6073224 </P><P>Email: <a href=\"Peachenquiries@rpa.gsi.gov.uk\">Peachenquiries@rpa.gsi.gov.uk</a>' WHERE footnote_description_period_sid=-183"
  end

  down do
    run "UPDATE footnote_descriptions SET description='Contact Details for lead Government Department are as follows: <P> <P>Fruit and Vegetables conformity controls <P> <P>Horticultural Marketing Inspectorate ( HMI) <P>Rural Payments Agency <P> Inspection Executive &#38; Development Unit <P> Epsom Road , <P>Guildford <P>Surrey <P>GU1 2LD. <P>Telephone: 01483 403340 <P>Email: HMI-TDC&#64;rpa.gsi.gov.uk' WHERE footnote_description_period_sid=-167"
    run "UPDATE footnote_descriptions SET description='Contact Details for lead Government Department are as follows: <P> <P>Fruit and Vegetables conformity controls <P> <P>Horticultural Marketing Inspectorate ( HMI) <P>Rural Payments Agency <P> Inspection Executive &#38; Development Unit <P> Epsom Road , <P>Guildford <P>Surrey <P>GU1 2LD. <P>Telephone: 01483 403340 <P>Email: HMI-TDC&#64;rpa.gsi.gov.uk' WHERE footnote_description_period_sid=-183"
  end
end
