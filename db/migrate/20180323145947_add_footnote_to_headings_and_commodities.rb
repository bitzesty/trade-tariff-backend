Sequel.migration do
  # Assign footnote_id/footnote_type_id to list of heading ids and their comodities. Id is 10 digits.
  # Seperate heading ids with spaces.
  # ex: rake tariff:assign_footnote_id_to_headings['002','05','8702000000 8705000000']

  up do
    # Eco footnote
    footnote = Footnote.where(footnote_id: '002', footnote_type_id: '05').first
    heading_ids = ['8702000000', '8705000000', '8710000000', '8802000000', '8803000000', '8805000000', '8906000000', '9301000000', '9302000000', '9303000000', '9304000000', '9305000000', '9306000000', '9307000000']

    Heading.where(goods_nomenclatures__goods_nomenclature_item_id: heading_ids).each do |heading|
      next if heading.footnotes.include?(footnote)
      puts "Associating footnote #{footnote.inspect} with heading #{heading.inspect}"
      associate_footnote_with_goods_nomenclature(heading, footnote)

      heading.commodities.each do |commodity|
        associate_footnote_with_goods_nomenclature(commodity, footnote)
        puts "Associating footnote #{footnote.inspect} with Commodity #{commodity.inspect}"
      end
    end
  end
end
