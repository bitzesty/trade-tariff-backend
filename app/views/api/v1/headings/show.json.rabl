object @heading

attributes :short_code, :code, :description, :has_measures,
           :third_country_duty_rate, :uk_vat_rate

if @heading.declarable?
  extends "api/v1/declarables/declarable", object: @heading
else
  child :chapter do
    attributes :short_code, :code, :description
  end

  child :section do
    attributes :title, :numeral, :position
  end

  node(:commodities) {
    @commodities.map do |commodity|
      partial("api/v1/commodities/commodity", object: commodity)
    end
  }
end
