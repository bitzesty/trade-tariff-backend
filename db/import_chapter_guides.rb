return unless ENV['RUNNING_TASK']

def seed_guides(guides)
  now = Time.now
  guides.each do |guide|
    new_guide ||= Guide.create(
      title: guide[:title],
      url: guide[:url]
    )
    guide[:chapters].each do |chapter_number|
      chapter = Chapter.filter(
        "goods_nomenclatures.goods_nomenclature_item_id LIKE ?",
        imported_id(chapter_number)
      ).take
      ChaptersGuides.create(
        goods_nomenclature_sid: chapter.goods_nomenclature_sid,
        guide_id: new_guide.id
      )
    end
  end
  seed_default_for_orphans(now)
end

def seed_default_for_orphans(now=Time.now)
  new_default_guide = Guide.create(
    title: "Classification of goods",
    url: "https://www.gov.uk/government/collections/classification-of-goods"
  )
  unguided_chapters.each do |goods_nomenclature_sid|
    ChaptersGuides.create(
      goods_nomenclature_sid: goods_nomenclature_sid,
      guide_id: new_default_guide.id
    )
  end
end

def imported_id(chapter_number)
  "#{chapter_number.to_s.rjust(2,'0')}00000000"
end

def unguided_chapters
  (Chapter.all.map {|c| c.goods_nomenclature_sid }) - (ChaptersGuides.all.map {|c| c.goods_nomenclature_sid})
end

guides = [
  {
    title: "Aircraft parts",
    url: "https://www.gov.uk/guidance/classifying-aircraft-parts-and-accessories",
    chapters: [86,89]
  },
  {
    title: "Audio and video equipment for import and export",
    url: "https://www.gov.uk/guidance/classifying-audio-and-video-equipment",
    chapters: [85]
  },
  {
    title: "Ceramics",
    url: "https://www.gov.uk/guidance/classifying-ceramics",
    chapters: [68,69]
  },
  {
    title: "Computers and software",
    url: "https://www.gov.uk/guidance/classifying-computers-and-software",
    chapters: [84]
  },
  {
    title: "Edible fruits, nuts and peel",
    url: "https://www.gov.uk/guidance/classifying-edible-fruits-nuts-and-peel",
    chapters: [8]
  },
  {
    title: "Edible vegetables, roots and tubers",
    url: "https://www.gov.uk/guidance/classifying-edible-vegetables-roots-and-tubers",
    chapters: [7]
  },
  {
    title: "Electric lamps",
    url: "https://www.gov.uk/guidance/classifying-electric-lamps",
    chapters: [85,90,94,95]
  },
  {
    title: "Footwear",
    url: "https://www.gov.uk/guidance/classifying-footwear",
    chapters: [64]
  },
  {
    title: "Herbal medicines, tonics and supplements",
    url: "https://www.gov.uk/guidance/classifying-herbal-medicines-supplements-tonics",
    chapters: [21,22,23,29,30]
  },
  {
    title: "Iron and Steel",
    url: "https://www.gov.uk/guidance/classifying-iron-and-steel",
    chapters: [72,73]
  },
  {
    title: "Leather",
    url: "https://www.gov.uk/guidance/classifying-leather",
    chapters: [41,42]
  },
  {
    title: "Monitors",
    url: "https://www.gov.uk/guidance/classifying-monitors-for-import-and-export",
    chapters: [85]
  },
  {
    title: "Organic chemicals",
    url: "https://www.gov.uk/guidance/classifying-organic-chemicals",
    chapters: [29]
  },
  {
    title: "Pharmaceutical products",
    url: "https://www.gov.uk/guidance/classifying-pharmaceutical-products",
    chapters: [30]
  },
  {
    title: "Placebos and comparators",
    url: "https://www.gov.uk/guidance/classifying-placebos-and-comparators",
    chapters: [21,30,38]
  },
  {
    title: "Plastics",
    url: "https://www.gov.uk/guidance/classifying-plastics",
    chapters: [39]
  },
  {
    title: "Rice",
    url: "https://www.gov.uk/guidance/classifying-rice",
    chapters: [10,16,19]
  },
  {
    title: "Textiles and textile articles",
    url: "https://www.gov.uk/guidance/classifying-textile-apparel",
    chapters: [61,62]
  },
  {
    title: "Tobacco and manufactured tobacco substitutes",
    url: "https://www.gov.uk/guidance/classifying-tobacco",
    chapters: [24]
  },
  {
    title: "Toys, games and sports equipment",
    url: "https://www.gov.uk/guidance/classifying-toys-games-and-sports-equipment",
    chapters: [95]
  },
  {
    title: "Vehicles, parts and accessories",
    url: "https://www.gov.uk/guidance/classifying-vehicles",
    chapters: [83,84,85,87]
  },
  {
    title: "Wood",
    url: "https://www.gov.uk/guidance/classifying-wood",
    chapters: [44]
  }
]

seed_guides(guides)
