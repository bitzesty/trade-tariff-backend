object @heading
attributes :short_code, :code, :description, :has_measures
child :chapter do
  attributes :short_code, :code, :description
end
child @heading.chapter.section do
  attributes :title, :numeral, :position
end

child(commodities: :commodities) do
  attributes :short_code, :code, :description, :substring,
  :third_country_duty_cache, :uk_vat_rate_cache
end

