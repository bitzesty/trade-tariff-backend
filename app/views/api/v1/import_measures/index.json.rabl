object false
node(:measures) do
  partial "api/v1/measures/_measures", object: @measures
end
# node(:third_country_measures) do
#   partial "api/v1/measures/_measures", :object => @measures[0]
# end
# node(:specific_measures) do
#   partial "api/v1/measures/_measures", :object => @measures[1]
# end
