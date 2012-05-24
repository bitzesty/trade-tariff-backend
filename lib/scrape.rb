class Scrape

  attr_accessor :scrape_id, :simulation_date

  def initialize(opts={})
    @agent = Mechanize.new
    @base_url = "http://tariff.businesslink.gov.uk/tariff-bl/print/commoditycode.html?"
    if opts[:export]
      @export="export=true&"
    else
      @export="export=false&"
    end
    if opts[:simulationDate]
      use_date = opts[:simulationDate]
    else
      use_date = Date.today.strftime("%d/%m/%y")
    end
    @date = "simulationDate=#{use_date}&"

    @scrape_id = opts[:scrape_id] || '01022110'
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

  def process_measures(table)
    trs = table.css('tbody tr')
    results = []
    trs.each_with_index do |row, i|
      hash = {}
      row.css('td').each_with_index do |node, i|
        case i
        when 0
          hash['Flag'] = node.css('img').attribute('src').value if node.css('img')
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

  def process_footnotes(table)
    trs = table.css('tbody tr')
    results = []
    trs.each_with_index do |row, i|
      hash = {}
      row.css('td').each_with_index do |node, i|
        case i
        when 0
          hash['Code'] = node.content
        when 1
          hash["Description"] = node.content
        end
      end
      results << hash
    end
    results
  end

  # Condition Document code Requirement Action  Duty expression
  def process_conditions(table)
    trs = table.css('tbody tr')
    results = []
    trs.each_with_index do |row, i|
      hash = {}
      row.css('td').each_with_index do |node, i|
        case i
        when 0
          hash['Condition'] = node.content
        when 1
          hash["Document code"] = node.content
        when 2
          hash["Requirement"] = node.content
        when 3
          hash["Action"] = node.content
        when 4
          hash["Duty expression"] = node.content
        end
      end
      results << hash
    end
    results
  end

  def process_tables
    results = {}
    tables.each_with_index do |t, i|
      if t.children.first.to_s == "<caption>Third country measures</caption>" #i == 2
        p 'Third country measures'
        results['third_country'] = process_measures(t)
      elsif t.children.first.to_s == "<caption>Measures for specific countries and country groups</caption>" #i == 3
        p 'Measures for specific countries and country groups'
        results["specific_countries"] = process_measures(t)
      elsif t.children.first.to_s == "<caption>Footnotes</caption>"
        results['footnotes'] = process_footnotes(t)
      else #
        results[t.children.first.content] = process_conditions(t)
      end
    end
    results
  end
end


#DUplicated data
#fields: code, description, duty
"Additional code"

# Example:
# require 'scrape'
# s = Scrape.new(scrape_id: '0101210000')
