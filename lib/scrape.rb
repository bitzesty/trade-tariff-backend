class Scrape

  def initialize
    @agent = Mechanize.new
    @base_url = "http://tariff.businesslink.gov.uk/tariff-bl/print/commoditycode.html?"
    @export="export=true&"
    @import="export=false&"
    @todays_date = Date.today.strftime("%d/%m/%y")
    @date = "simulationDate=#{@todays_date}&"
    @obj_id="id=01022110"
  end

  def page
    puts 'fetching...'
    @page ||= @agent.get(hit_url)
  end

  def noko_body
    page.at("//body")
  end

  def tables
    noko_body.css('table')
  end

  def hit_url
    @base_url + @export + @date + @obj_id
  end

  def image_base_url
    "http://tariff.businesslink.gov.uk/"
  end

  def img_path(url)
    image_base_url + url
  end

  def process_third_country_measures(table)
    trs = table.css('tbody tr')
    trs.each do |row|
      # binding.pry
      row.children.each_with_index do |td, i|
        binding.pry
        if td && td[:class] = 'flag'
          flag = td.children[1]['src']
          puts img_path(flag)
        end
      end
    end
  end

  def process_tables(tables)
    #fields: Measure Type, Duty rates / prohibitions, Additional codes, Conditions, Exclusions, Legal Act Footnote
    tables.each_with_index do |t, i|
      if i == 2 && t.children.first.to_s == "<caption>Third country measures</caption>"
        process_third_country_measures(t)
      else
        puts "failed to process third country measures for: #{obj_id}"
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
