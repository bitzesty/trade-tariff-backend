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

  describe "PUT /commodities/:id" do
    let!(:commodity)    { create(:commodity) }
    let(:synonyms) { Forgery(:basic).text }
    let!(:api_key)    { create(:api_key) }

    it 'assigns synonyms to commodity when authenticated' do
      commodity.synonyms.should be_blank
      api_key.access_token.should_not be_blank

      put "/commodities/#{commodity.to_param}", { commodity: { synonyms: synonyms } }, authorization: ActionController::HttpAuthentication::Token.encode_credentials(api_key.access_token)
      response.status.should == 200
      result = JSON.parse(response.body)

      commodity.reload.synonyms.should == synonyms
    end
  end

end
