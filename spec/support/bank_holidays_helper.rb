module BankHolidaysHelper
  def stub_bank_holidays_get_request
    json = {
      "division" => "england-and-wales",
      "events" => [
        {"title" => "Day 1","date" => "2016-11-30","notes" => "","bunting" => true},
        {"title" => "Day 2","date" => "2015-10-07","notes" => "","bunting" => false},
        {"title" => "Day 3","date" => "2016-10-09","notes" => "","bunting" => true}
      ]
    }.to_json
    allow(Net::HTTP).to receive(:get).with(URI(BankHolidays::URL)).and_return(json)
  end
end
