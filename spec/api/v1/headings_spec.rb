require 'spec_helper'

describe Api::V1 do
  describe "GET /headings/:id" do
    let!(:heading)    { create(:heading_with_commodities) }

    before {
      get "/headings/#{heading.to_param}"
    }

    subject { JSON.parse(response.body) }

    it 'returns a particular heading' do
      subject.at_json_path("short_code").should == heading.short_code
    end

    it 'returns associated commodities' do
      subject.at_json_path("commodities").should_not be_blank
    end
  end
end
