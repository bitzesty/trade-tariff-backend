object @commodity
attribute :id, :code, :description
child @commodity.heading.chapter do
  attributes :id, :code, :description
end
child @commodity.heading.chapter.section do
  attributes :id, :title
end
child :heading do
  attributes :id, :code, :description
end

child :measures do |measure|
  attributes :id, :measure_type, :duty_rates

  child(:legal_act, if: ->(measure) { measure.legal_act.present? }) do
    attributes :id, :code, :url
  end

  child(conditions: :conditions) do
    attributes :id, :document_code, :requirement, :action, :duty_expression
  end

  child(excluded_countries: :excluded_countries) do
    attributes :id, :name, :iso_code
  end

  child(footnotes: :footnotes) do
    attributes :id, :code, :description
  end

  child(additional_codes: :additional_codes) do
    attributes :id, :code, :description
  end

  child(region: :region) do
    attributes :id, :name, :description
    node(:type) { |r| r.class_name }
    node(:countries, if: ->(region) { region.class_name == 'CountryGroup' }) do |region|
      child(countries: :countries) do
        attributes :id, :name
      end
    end
  end
end
