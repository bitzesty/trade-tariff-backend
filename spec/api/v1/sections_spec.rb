require 'spec_helper'

describe Api::V1 do
  describe "GET /api/sections" do
    let!(:section1)    { create(:section) }
    let!(:section2)    { create(:section) }

    before {
      get "/api/sections"
    }

    subject { JSON.parse(response.body) }

    it 'returns a list of posts' do
      subject.select { |s| s["_id"] == section1.id.to_s }.should_not be_blank
      subject.select { |s| s["_id"] == section2.id.to_s }.should_not be_blank
    end
  end
end
