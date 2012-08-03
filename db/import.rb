sections = [
  {position: 1, numeral: 'I',     title: "Live animals; animal products (chapter 1 - 5)", chapters: ("01".."05")},
  {position: 2, numeral: 'II',    title: "Vegetable products (chapter 6 - 14)", chapters: ("06".."14")},
  {position: 3, numeral: 'III',   title: "Animal or vegetable fats and oils and their cleavage products; prepared edible fats; animal or vegetable waxes (chapter 15)", chapters: ("15".."15")},
  {position: 4, numeral: 'IV',    title: "Prepared foodstuffs; beverages, spirits and vinegar; tobacco and manufactured tobacco substitutes (chapter 16 - 24)", chapters: ("16".."24")},
  {position: 5, numeral: 'V',     title: "Mineral products (chapter 25 - 27)", chapters: ("25".."27")},
  {position: 6, numeral: 'VI',    title: "Products of the chemical or allied industries (chapter 28 - 38)", chapters: ("28".."38")},
  {position: 7, numeral: 'VII',   title: "Plastics and articles thereof; rubber and articles thereof (chapter 39 - 40)", chapters: ("39".."40")},
  {position: 8, numeral: 'VIII',  title: "Raw hides and skins, leather, furskins and articles thereof; saddlery and harness; travel goods, handbags and similar containers; articles of animal gut (other than silkworm gut) (chapter 41 - 43)", chapters: ("41".."43")},
  {position: 9, numeral: 'IX',    title: "Wood and articles of wood; wood charcoal; cork and articles of cork; manufactures of straw, of esparto or of other plaiting materials; basketware and wickerwork (chapter 44 - 46)", chapters: ("44".."46")},
  {position: 10, numeral: 'X',    title: "Pulp of wood or of other fibrous cellulosic material; recovered (waste and scrap) paper or paperboard; paper and paperboard and articles thereof (chapter (chapter 47 - 49)", chapters: ("47".."49")},
  {position: 11, numeral: 'XI',   title: "Textiles and textile articles (chapter 50 - 63)", chapters: ("50".."63")},
  {position: 12, numeral: 'XII',  title: "Footwear, headgear, umbrellas, sun umbrellas, walking-sticks, seat-sticks, whips, riding-crops and parts thereof; prepared feathers and articles made therewith; artificial flowers; articles of human hair (chapter 64 - 67)", chapters: ("64".."67")},
  {position: 13, numeral: 'XIII', title: "Articles of stone, plaster, cement, asbestos, mica or similar materials; ceramic products; glass and glassware (chapter 68 - 70)", chapters: ("68".."70")},
  {position: 14, numeral: 'XIV',  title: "Natural or cultured pearls, precious or semi-precious stones, precious metals, metals clad with precious metal and articles thereof; imitation jewellery; coins (chapter 71)", chapters: ("71".."71")},
  {position: 15, numeral: 'XV',   title: "Base metals and articles of base metal (chapter 72 - 83)", chapters: ("72".."83")},
  {position: 16, numeral: 'XVI',  title: "Machinery and mechanical appliances; electrical equipment; parts thereof, sound recordes and reproducers, television image and sound recorders and reproducers, and parts and accessories of such articles (chapter 84 - 85)", chapters: ("84".."85")},
  {position: 17, numeral: 'XVII', title: "Vehicles, aircraft, vessels and associated transport equipment (chapter 86 - 89)", chapters: ("86".."89")},
  {position: 18, numeral: 'XVIII',title: "Optical, photographic, cinematographic, measuring, checking, precision, medical or surgical instruments and apparatus; clocks and watches; musical instruments; parts and accessories thereof (chapter 90 - 92)", chapters: ("90".."92")},
  {position: 19, numeral: 'XIX',  title: "Arms and ammunition; parts and accessories thereof (chapter 93)", chapters: ("93".."93")},
  {position: 20, numeral: 'XX',   title: "Miscellaneous manufactured articles (chapter 94 - 96)", chapters: ("94".."96")},
  {position: 21, numeral: 'XXI',  title: "Works of art, collectors' pieces and antiques (chapter 97 - 99)", chapters: ("97".."99")}
]

sections.each do |sec|
  Section.find_or_create(position: sec[:position], numeral: sec[:numeral], title: sec[:title])
end

# Map chapters to sections
Chapter.all.each do |chapter|
  section = sections.detect { |s| chapter.short_code.in?(s[:chapters]) }
  section = Section.where(position: section[:position], numeral: section[:numeral]).first
  section.add_chapter chapter
end
