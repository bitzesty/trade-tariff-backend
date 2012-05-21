require 'spec_helper'

describe Api::V1 do
  describe "GET /api/commodities" do
    let!(:commodity1)    { create(:commodity) }
    let!(:commodity2)    { create(:commodity) }

    before {
      get "/api/commodities"
    }

    subject { JSON.parse(response.body) }

    it 'returns a list of posts' do
      subject.select { |s| s["_id"] == commodity1.id.to_s }.should_not be_blank
      subject.select { |s| s["_id"] == commodity2.id.to_s }.should_not be_blank
    end
  end
end
