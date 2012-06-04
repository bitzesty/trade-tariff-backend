require 'spec_helper'

describe Api::V1 do
  describe "GET /commodities/:id" do
    let!(:commodity)    { create(:commodity) }

    before {
      get "/commodities/#{commodity.to_param}"
    }

    subject { JSON.parse(response.body) }

    it 'returns a particular commodity' do
      subject.at_json_path("code").should == commodity.code
    end
  end

  describe "GET /commodities/:id/import_measures" do
    let!(:commodity)    { create(:commodity) }
    let!(:export_measure)    { create(:measure, :export, measurable: commodity) }
    let!(:import_measure)    { create(:measure, :import, measurable: commodity) }

    before {
      get "/commodities/#{commodity.to_param}/import_measures"
    }

    subject { JSON.parse(response.body) }

    it 'returns commoditys import measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == import_measure.id.to_s }.should_not be_blank
    end

    it 'does not return commoditys export measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == export_measure.id.to_s }.should be_blank
    end
  end

  describe "GET /commodities/:id/export_measures" do
    let!(:commodity)    { create(:commodity) }
    let!(:export_measure)    { create(:measure, :export, measurable: commodity) }
    let!(:import_measure)    { create(:measure, :import, measurable: commodity) }

    before {
      get "/commodities/#{commodity.to_param}/export_measures"
    }

    subject { JSON.parse(response.body) }

    it 'returns commoditys export measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == export_measure.id.to_s }.should_not be_blank
    end

    it 'does not return commoditys import measures' do
      subject["third_country_measures"].select { |measure| measure["id"] == import_measure.id.to_s }.should be_blank
    end
  end

  describe "PUT /commodities/:id" do
    let!(:commodity)    { create(:commodity) }
    let(:synonyms) { Forgery(:basic).text }

    it 'assigns synonyms to commodity' do
      commodity.synonyms.should be_blank

      put "/commodities/#{commodity.to_param}", { commodity: { synonyms: synonyms } }
      result = JSON.parse(response.body)
      response.status.should == 200

      commodity.reload.synonyms.should == synonyms
    end
  end
end
