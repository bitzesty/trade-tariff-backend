module XlsImporter
  def process_substr(x)
    x.nil? ? 0 : x.strip.split(' ').count
  end

  def process_id(x)
    x.gsub(" ", '')
  end

  def get_chapter(str)
    str[0..1]
  end

  def get_heading(str)
    str[0..3]
  end

  def build_attrs(row)
    { code: process_id(row[0]), description: row[6].strip, hier_pos: row[4], substring: (process_substr(row[5])) }
  end

  def is_chapter?(attrs)
    attrs[:hier_pos] == 2 && attrs[:substring] == 0
  end

  def is_heading?(attrs)
    attrs[:hier_pos] == 4 && attrs[:substring] == 0
  end

  def find_section_for_chapter(attrs)
    chapter = get_chapter(attrs).to_i
    section = case chapter
              when 1..5
                1
              when 6..14
                2
              when 15
                3
              when 16..24
                4
              when 25..27
                5
              when 28..38
                6
              when 39..40
                7
              when 41..43
                8
              when 44..46
                9
              when 47..49
                10
              when 50..63
                11
              when 64..67
                12
              when 68..70
                13
              when 71
                14
              when 72..83
                15
              when 84..85
                16
              when 86..89
                17
              when 90..92
                18
              when 93
                19
              when 94..96
                20
              when 97..99
                21
              end
  end

  def create_objects(nomenclature, attrs)
    if is_chapter?(attrs)
      section_pos = find_section_for_chapter(attrs[:code])
      attrs.delete(:hier_pos)
      attrs.delete(:substring)
      chapter = Chapter.new(attrs)
      chapter.section = Section.where(position: section_pos).first
      chapter.nomenclature = nomenclature
      chapter.save
    elsif is_heading?(attrs)
      chapter = Chapter.where({ code: /^#{get_chapter(attrs[:code])}/i }).first
      Heading.create(attrs.merge({chapter: chapter, nomenclature: nomenclature}))
    else
      heading = Heading.where({ code: /^#{get_heading(attrs[:code])}/i }).first
      if heading
        commodity = Commodity.new(attrs)
        commodity.heading = heading
        commodity.nomenclature = nomenclature
        commodity.save
      else
        #Errors in xls - no heading for a subheading treat as heading
        chapter = Chapter.where({ code: /^#{get_chapter(attrs[:code])}/i }).first
        Heading.create(attrs.merge({chapter: chapter, nomenclature: nomenclature}))
      end
    end
  end
end

include XlsImporter

#####################################
# Loading Data
#####################################

sections = [
  {position: 1, numeral: 'I',     title: "Live animals; animal products (chapter 1 - 5)"},
  {position: 2, numeral: 'II',    title: "Vegetable products (chapter 6 - 14)"},
  {position: 3, numeral: 'III',   title: "Animal or vegetable fats and oils and their cleavage products; prepared edible fats; animal or vegetable waxes (chapter 15)"},
  {position: 4, numeral: 'IV',    title: "Prepared foodstuffs; beverages, spirits and vinegar; tobacco and manufactured tobacco substitutes (chapter 16 - 24)"},
  {position: 5, numeral: 'V',     title: "Mineral products (chapter 25 - 27)"},
  {position: 6, numeral: 'VI',    title: "Products of the chemical or allied industries (chapter 28 - 38)"},
  {position: 7, numeral: 'VII',   title: "Plastics and articles thereof; rubber and articles thereof (chapter 39 - 40)"},
  {position: 8, numeral: 'VIII',  title: "Raw hides and skins, leather, furskins and articles thereof; saddlery and harness; travel goods, handbags and similar containers; articles of animal gut (other than silkworm gut) (chapter 41 - 43)"},
  {position: 9, numeral: 'IX',    title: "Wood and articles of wood; wood charcoal; cork and articles of cork; manufactures of straw, of esparto or of other plaiting materials; basketware and wickerwork (chapter 44 - 46)"},
  {position: 10, numeral: 'X',    title: "Pulp of wood or of other fibrous cellulosic material; recovered (waste and scrap) paper or paperboard; paper and paperboard and articles thereof (chapter (chapter 47 - 49)"},
  {position: 11, numeral: 'XI',   title: "Textiles and textile articles (chapter 50 - 63)"},
  {position: 12, numeral: 'XII',  title: "Footwear, headgear, umbrellas, sun umbrellas, walking-sticks, seat-sticks, whips, riding-crops and parts thereof; prepared feathers and articles made therewith; artificial flowers; articles of human hair (chapter 64 - 67)"},
  {position: 13, numeral: 'XIII', title: "Articles of stone, plaster, cement, asbestos, mica or similar materials; ceramic products; glass and glassware (chapter 68 - 70)"},
  {position: 14, numeral: 'XIV',  title: "Natural or cultured pearls, precious or semi-precious stones, precious metals, metals clad with precious metal and articles thereof; imitation jewellery; coins (chapter 71)"},
  {position: 15, numeral: 'XV',   title: "Base metals and articles of base metal (chapter 72 - 83)"},
  {position: 16, numeral: 'XVI',  title: "Machinery and mechanical appliances; electrical equipment; parts thereof, sound recordes and reproducers, television image and sound recorders and reproducers, and parts and accessories of such articles (chapter 84 - 85)"},
  {position: 17, numeral: 'XVII', title: "Vehicles, aircraft, vessels and associated transport equipment (chapter 86 - 89)"},
  {position: 18, numeral: 'XVIII',title: "Optical, photographic, cinematographic, measuring, checking, precision, medical or surgical instruments and apparatus; clocks and watches; musical instruments; parts and accessories thereof (chapter 90 - 92)"},
  {position: 19, numeral: 'XIX',  title: "Arms and ammunition; parts and accessories thereof (chapter 93)"},
  {position: 20, numeral: 'XX',   title: "Miscellaneous manufactured articles (chapter 94 - 96)"},
  {position: 21, numeral: 'XXI',  title: "Works of art, collectors' pieces and antiques (chapter 97 - 99)"}
]

puts "Creating Nomenclature..."
nomenclature = Nomenclature.find_or_create_by(as_of_date: Date.today)

puts "Loading Sections..."
sections.each do |sec|
  Section.create(sec, nomenclature: nomenclature)
end

Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open Rails.root.join('db/goods-nomenclature.xls')
sheet1 = book.worksheet 0
n_rows = sheet1.count
p "#{n_rows} Rows loaded"
pbar = ProgressBar.new("Loading data", n_rows)

sheet1.each 1 do |row|
  x = build_attrs(row)
  create_objects(nomenclature, x)
  pbar.inc
end
