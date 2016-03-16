class TaricFileNameGenerator

  attr_reader :date
  delegate :taric_query_url_template, :host, to: TariffSynchronizer

  def initialize(date)
    @date = date
  end

  def url
    format(taric_query_url_template, host: host, date: date.strftime("%Y%m%d"))
  end
end
