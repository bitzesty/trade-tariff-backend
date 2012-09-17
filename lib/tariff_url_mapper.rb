class TariffUrlMapper
    cattr_accessor :logger
    self.logger = Logger.new('log/mapper.log')

   def initialize(opts={})
    @base_url = if opts[:heading]
                  "http://tariff.businesslink.gov.uk/tariff-bl/export/headingDeclarative.html?"
                else
                  "http://tariff.businesslink.gov.uk/tariff-bl/export/commoditycode.html?"
                end

    @new_base_url = if opts[:heading]
                      "https://www.gov.uk/trade-tariff/headings/"
                    else
                      "https://www.gov.uk/trade-tariff/commodities/"
                    end

    if opts[:export]
      @export="export=true&"
      @new_export = "#export"
    else
      @export="export=false&"
      @new_export = "#import"
    end
    if opts[:simulationDate]
      use_date = opts[:simulationDate]
    else
      use_date = Date.parse("2012-06-05")
    end
    @date = "simulationDate=#{use_date.strftime("%d/%m/%y")}&"
    @new_date = "?as_of=#{use_date.strftime("%Y-%m-%d")}"
    @eu_date = use_date.strftime("%Y%m%d")

    if opts[:heading]
      @obj_id="id=#{opts[:scrape_id].first(4)}"
    else
      @scrape_id = opts[:scrape_id]
      @obj_id="id="
    end
  end

  def old_url
    if @scrape_id.present?
      @base_url + @export + @date + @obj_id + @scrape_id
    else
      @base_url + @export + @date + @obj_id
    end
  end
  
  def new_url
    @new_base_url + @scrape_id + @new_date + @new_export
  end

  def eu_url
    "http://ec.europa.eu/taxation_customs/dds2/taric/measures.jsp?Lang=en&SimDate=#{@eu_date}&Taric=#{@scrape_id}&LangDescr=en"
  end

  def to_csv
    "#{old_url},#{new_url},#{eu_url}"
  end

  def self.generate_random
    TimeMachine.at("2012-06-05") do
      Commodity.actual.order(:validity_start_date.desc).limit(200).to_a.each do |c|
        logger.info TariffUrlMapper.new({scrape_id: c.code}).to_csv
      end
    end
  end
end