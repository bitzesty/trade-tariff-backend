require 'spec_helper'

describe Api::V1 do
  describe "GET /api/sections" do
    let!(:section1)    { create(:section) }
    let!(:section2)    { create(:section) }

    before {
      get "/api/sections"
    }

    subject { JSON.parse(response.body) }

    it 'returns a list of sections' do
      subject.select { |s| s["_id"] == section1.id.to_s }.should_not be_blank
      subject.select { |s| s["_id"] == section2.id.to_s }.should_not be_blank
    end
  end

  describe "GET /api/sections/:id" do
    let!(:section)    { create(:section, :with_chapters) }

    before {
      get "/api/sections/#{section.id}"
    }

    subject { JSON.parse(response.body) }

    # it 'returns particular section' do
    #   subject.at_json_path("_id").should == section.id.to_s
    # end

    # it 'includes chapter info' do
    #   subject.at_json_path("chapters").should_not be_blank
    # end
  end
end
