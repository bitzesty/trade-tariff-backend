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

  describe "GET /headings/:id/import_measures" do
    let!(:heading)    { create(:heading) }
    let!(:export_measure)    { create(:measure, :export, measurable: heading) }
    let!(:import_measure)    { create(:measure, :import, measurable: heading) }

    before {
      get "/headings/#{heading.to_param}/import_measures"
    }

    subject { JSON.parse(response.body) }

    it 'returns headings import measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == import_measure.id.to_s }.should_not be_blank
    end

    it 'does not return headings export measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == export_measure.id.to_s }.should be_blank
    end
  end

  describe "GET /headings/:id/export_measures" do
    let!(:heading)    { create(:heading) }
    let!(:export_measure)    { create(:measure, :export, measurable: heading) }
    let!(:import_measure)    { create(:measure, :import, measurable: heading) }

    before {
      get "/headings/#{heading.to_param}/export_measures"
    }

    subject { JSON.parse(response.body) }

    it 'returns headings export measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == export_measure.id.to_s }.should_not be_blank
    end

    it 'does not return headings import measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == import_measure.id.to_s }.should be_blank
    end
  end
end
