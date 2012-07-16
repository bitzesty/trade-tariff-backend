attributes :id, :measure_type_description, :duty_rate

# child(:legal_act, if: ->(measure) { measure.legal_act.present? }) do
#   attributes :code, :url
# end

# child(conditions: :conditions) do
#   attributes :id, :document_code, :requirement, :action, :duty_expression
# end

# child(excluded_countries: :excluded_countries) do
#   attributes :name, :iso_code
# end

# child(footnotes: :footnotes) do
#   attributes :id, :code, :description
# end

# child(additional_codes: :additional_codes) do
#   attributes :id, :code, :description
# end

# child(region: :region) do
#   attributes :name, :description
#   node(:type) { |r| r.class_name }
#   node(:countries, if: ->(region) { region.class_name == 'CountryGroup' }) do |region|
#     child(countries: :countries) do
#       attributes :name
#     end
#   end
# end
