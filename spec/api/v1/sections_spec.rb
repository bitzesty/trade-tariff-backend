require 'spec_helper'

describe Api::V1 do
  describe "GET /sections" do
    let!(:section1)    { create(:section) }
    let!(:section2)    { create(:section) }

    before {
      get "/sections"
    }

    subject { JSON.parse(response.body) }

    it 'returns a list of sections' do
      subject.select { |s| s["position"] == section1.position }.should_not be_blank
      subject.select { |s| s["position"] == section2.position }.should_not be_blank
    end
  end

  describe "GET /sections/:id" do
    let!(:section)    { create(:section_with_chapters) }

    before {
      get "/sections/#{section.to_param}"
    }

    subject { JSON.parse(response.body) }

    it 'returns particular section' do
      subject.at_json_path("position").should == section.position
    end

    it 'includes chapter info' do
      subject.at_json_path("chapters").should_not be_blank
    end
  end
end
