require 'spec_helper'

describe Api::V1 do
  describe "GET /api/headings/:id" do
    let!(:heading)    { create(:heading) }

    before {
      get "/api/headings/#{heading.id}"
    }

    subject { JSON.parse(response.body) }

    it 'returns a particular heading' do
      subject.at_json_path("_id").should == heading.id.to_s
    end
  end
end
