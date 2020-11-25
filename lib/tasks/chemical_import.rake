namespace :chemical do
  desc "Import chamicals (CASRN, name) and asssociations with GNs"
  task import: :environment do
    ARGV.each { |a| task a.to_sym do ; end }

    ChemicalsGoodsNomenclatures.unrestrict_primary_key

    filepath = File.join(Rails.root, 'db', ARGV[1].to_s)
    ods = File.open(filepath, 'r')
    
    ods.each do |r|
      row = r.gsub(/["\n]/, '').split(',', 3)
      params = {
        goods_nomenclature_sid: row[0].gsub(/\D/, '').ljust(10, "0"),
        cas: row[1].strip,
        name: row[2].strip
      }
      gn = GoodsNomenclature.where(goods_nomenclature_item_id: params[:goods_nomenclature_sid]).first

      if gn
        # create chemical with :cas
        c = Chemical.find_or_create(cas: params[:cas])

        # create chemical name with :name
        c.add_chemical_name({name: params[:name]}) unless c.chemical_names.map(&:name).include?(params[:name])

        # create chemical <<-MTM->> goods_nomenclature association
        puts "#{c.cas}--#{gn.goods_nomenclature_item_id}"
        ChemicalsGoodsNomenclatures.find_or_create(chemical_id: c.id, goods_nomenclature_sid: gn.goods_nomenclature_sid)
      else
        puts "Failed to find GN: #{row.inspect}"
      end
    end
  end
end
