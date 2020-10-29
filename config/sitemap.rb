SitemapGenerator::Sitemap.default_host = ENV["TARIFF_API_HOST"]

SitemapGenerator::Sitemap.create do
  Commodity.paged_each do |commodity|
    add "/commodities/#{commodity.goods_nomenclature_item_id}"
  end
  Heading.paged_each do |heading|
    add "/headings/#{heading.short_code}"
  end
end
