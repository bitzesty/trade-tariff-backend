collection @commodities
cache 'commodities', expires_at: actual_date.end_of_day

attribute :goods_nomenclature_sid => :sid

glue :chapter do
  attributes :short_code => :chapter
end

attribute :goods_nomenclature_item_id => :goods_nomenclature_item_id
attribute :description => :description
attribute :number_indents => :number_of_indents
attribute :producline_suffix => :product_line_suffix

node do |c|
  duty = c.measures.select(&:third_country?).first
  duty_amount = duty&.duty_expression
  attribute :third_country_duty => duty_amount
end

node do |c|
  vat = c.measures.select(&:vat?).first
  standard_vat =  nil
  zero_vat =      nil
  reduced_vat =   nil
  # exempt_vat =    nil

  if vat
    type = vat.measure_type_id
    standard_vat =  (type == 'VTS')
    zero_vat =      (type == 'VTZ')
    reduced_vat =   (type == 'VTA')
    # exempt_vat =    (type == 'VTE')
  end
  attributes :standard_vat => standard_vat,
    :zero_vat => zero_vat,
    :reduced_vat => reduced_vat
    # :exempt_vat => exempt_vat
end

node do |c|
  attribute :url => "https://www.trade-tariff.service.gov.uk/v1/commodities/#{c.goods_nomenclature_item_id}.json"
end
