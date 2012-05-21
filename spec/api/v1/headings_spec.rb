require 'spec_helper'

describe Api::V1 do
  describe "GET /api/headings" do
    let!(:heading1)    { create(:heading) }
    let!(:heading2)    { create(:heading) }

    before {
      get "/api/headings"
    }

    subject { JSON.parse(response.body) }

    it 'returns a list of posts' do
      subject.select { |s| s["_id"] == heading1.id.to_s }.should_not be_blank
      subject.select { |s| s["_id"] == heading2.id.to_s }.should_not be_blank
    end
  end
end
