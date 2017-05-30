module BankHolidaysHelper
  def stub_govuk_holidays_get_request
    json = {
      "division" => "england-and-wales",
      "events" => [
        {"title" => "Day 1","date" => "2016-11-30","notes" => "","bunting" => true},
        {"title" => "Day 2","date" => "2015-10-07","notes" => "","bunting" => false},
        {"title" => "Day 3","date" => "2016-10-09","notes" => "","bunting" => true}
      ]
    }.to_json
    stub_request(:get, BankHolidays::URL).
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.gov.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: json, headers: {})
  end

  def stub_holidays_gem_between_call
    res = [
      {date: Date.parse('2016-11-30'), name: "Day 1", regions: [:be_fr]},
      {date: Date.parse('2015-10-07'), name: "Day 2", regions: [:gb]},
      {date: Date.parse('2016-10-09'), name: "Day 3", regions: [:be_nl]}
    ]
    allow(Holidays).to receive(:between).and_return(res)
  end
end
