object @commodity
attribute :short_code, :code, :description, :synonyms,
    :third_country_duty_cache, :uk_vat_rate_cache

child @commodity.heading.chapter do
  attributes :short_code, :code, :description
end
child @commodity.heading.chapter.section do
  attributes :title, :position
end
child :heading do
  attributes :short_code, :code, :description
end
