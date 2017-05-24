require 'net/http'
require 'json'

module BankHolidays
  URL = 'https://www.gov.uk/bank-holidays/england-and-wales.json'

  def self.last(n)
    # we can add caching because gov.uk returns holidays till 2018
    response = Rails.cache.fetch('gov-uk-bank-holidays', expires_in: 10.days) do
      Net::HTTP.get(URI(URL))
    end
    dates = JSON.parse(response)['events'].map{ |e| Date.parse(e['date']) }
    dates.select!{ |d| d <= Date.today }
    dates += ((Date.today - n + 1)..Date.today).to_a.select{ |d| d.saturday? || d.sunday? }
    dates.sort.last(n)
  end
end
