Sequel.migration do
  up do
    FootnoteDescription.where(footnote_type_id: '04', footnote_id: '003')
                       .update(description: 'Contact Details for lead Government Department are as follows: <P> <P>Rabies &#38; Hares - Animal Health Certificate Animal - Rabies Pathogens, Hares <P> <P>Animal Health & Veterinary Laboratories Agency</P><P>Ground Floor, Redwing House</P><P>Hedgerows Business Park</P><P>Colchester Road</P><P>Chelmsford</P><P>CM2 5PB</P><P>Telephone: 01245 398298</P><P> <P>Animal Pathogens Import Licence <P> <P>The Pathogens Licensing Team <P>Defra <P>Area 5A, Nobel House <P>17 Smith Square,London <P>SW1P 3JR <P>Telephone: 020 7238 6211/6195 <P>Fax: 020 7238 6105 <P>Email:pathogens&#64;defra.gsi.gov.uk <P>Website: <a href="http://www.defra.gov.uk/animal-diseases/pathogens/">www.defra.gov.uk/animal-diseases/pathogens/</a>')
  end

  down do
    FootnoteDescription.where(footnote_type_id: '04', footnote_id: '003')
                       .update(description: 'Contact Details for lead Government Department are as follows: <P> <P>Rabies &#38; Hares - Animal Health Certificate Animal - Rabies Pathogens, Hares <P> <P>Government Offices <P>Beeches Road <P>Chelmsford <P>Essex <P>CM1 2RU <P>Telephone: 01245 358383/490886 <P> <P>Animal Pathogens Import Licence <P> <P>The Pathogens Licensing Team <P>Defra <P>Area 5A, Nobel House <P>17 Smith Square,London <P>SW1P 3JR <P>Telephone: 020 7238 6211/6195 <P>Fax: 020 7238 6105 <P>Email:pathogens&#64;defra.gsi.gov.uk <P>Website: <a href=\"http://www.defra.gov.uk/animal-diseases/pathogens/\">www.defra.gov.uk/animal-diseases/pathogens/</a>')
  end
end
