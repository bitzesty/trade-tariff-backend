class Scrape

  attr_accessor :scrape_id, :simulation_date, :type_of_commodity

  def initialize
    @agent = Mechanize.new
    @base_url = "http://tariff.businesslink.gov.uk/tariff-bl/print/commoditycode.html?"
    @export="export=true&"
    @import="export=false&"
    @todays_date = Date.today.strftime("%d/%m/%y")
    @date = "simulationDate=#{@todays_date}&"
    @scrape_id='01022110'
    @obj_id="id="
  end

  def page
    puts 'fetching...'
    @page = @agent.get(hit_url)
  end

  def noko_body
    page.at("//body")
  end

  def tables
    noko_body.css('table')
  end

  def hit_url
    @base_url + @export + @date + @obj_id + @scrape_id
  end

  def image_base_url
    "http://tariff.businesslink.gov.uk/"
  end

  def img_path(url)
    "#{image_base_url}#{url}"
  end

  def process_third_country_measures(table)
    trs = table.css('tbody tr')
    results = []
    trs.each_with_index do |row, i|
      hash = {}
      row.css('td').each_with_index do |node, i|
        case i
        when 0
          hash['flag'] = node.css('img').attribute('src').value if node.css('img')
        when 1
          hash["Measure Type"] = node.content
        when 2
          hash["Duty rates"] = node.content
        when 3
          hash["Additional codes"] = node.content
        when 4
          hash["Conditions"] = node.content
        when 5
          hash["Exclusions"] = node.content
        when 6
          hash["Legal Act"] = node.content
        when 7
          hash["Footnote"] = node.content
        end
      end
      results << hash
    end
    results
  end

  def process_tables
    #fields: Measure Type, Duty rates / prohibitions, Additional codes, Conditions, Exclusions, Legal Act Footnote
    tables.each_with_index do |t, i|
      if t.children.first.to_s == "<caption>Third country measures</caption>" #i == 2
        p 'Third country measures'
        process_third_country_measures(t)
      else
        # puts "failed to process third country measures for: #{@obj_id}"
      end
    end
  end
end

#fields: Country, Measure Type,  Duty rates / prohibitions, Additional codes,  Conditions,  Exclusions,  Legal Act, Footnotes
"Measures for specific countries and country groups"

#DUplicated data
#fields: code, description, duty
"Additional code"

#fields: Code, Description
"Footnotes"

# require 'scrape'
# s = Scrape.new
