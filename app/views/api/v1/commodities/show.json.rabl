object @commodity

attribute :short_code, :code, :description, :synonyms,
    :third_country_duty_cache, :uk_vat_rate_cache

if @commodity.is_a?(Commodity)
  child @commodity.heading.chapter do
    attributes :short_code, :code, :description
  end
  child @commodity.heading.chapter.section do
    attributes :title, :position
  end
  child :heading do
    attributes :short_code, :code, :description
  end
  child(ancestors: :ancestors) do
    attribute :short_code, :code, :description
  end
elsif @commodity.is_a?(Heading)
  child @commodity.chapter do
    attributes :short_code, :code, :description
  end
  child @commodity.chapter.section do
    attributes :title, :position
  end
end
