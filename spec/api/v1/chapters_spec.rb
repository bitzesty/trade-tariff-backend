require 'spec_helper'

describe Api::V1 do
  describe "GET /api/chapters" do
    let!(:chapter1)    { create(:chapter) }
    let!(:chapter2)    { create(:chapter) }

    before {
      get "/api/chapters"
    }

    subject { JSON.parse(response.body) }

    it 'returns a list of posts' do
      subject.select { |s| s["_id"] == chapter1.id.to_s }.should_not be_blank
      subject.select { |s| s["_id"] == chapter2.id.to_s }.should_not be_blank
    end
  end
end
