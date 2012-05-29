require 'spec_helper'

describe Api::V1 do
  describe "GET /commodities/:id" do
    let!(:commodity)    { create(:commodity) }

    before {
      get "/commodities/#{commodity.to_param}"
    }

    subject { JSON.parse(response.body) }

    it 'returns a particular commodity' do
      subject.at_json_path("id").should == commodity.id.to_s
    end
  end
end
