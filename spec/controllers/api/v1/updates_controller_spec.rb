require 'rails_helper'

describe Api::V1::UpdatesController, "GET #index" do
  render_views

  let(:pattern) {
    { updates:
      [
       { update_type: "TariffSynchronizer::TaricUpdate",
         state: String,
         filename: String
       }.ignore_extra_keys!,
       { update_type: "TariffSynchronizer::TaricUpdate",
         state: String,
         filename: String
       }.ignore_extra_keys!
      ].ignore_extra_values!
    }.ignore_extra_keys!
  }

  context 'when records are present' do
    let!(:taric_update1) { create :taric_update, :applied, issue_date: Date.yesterday }
    let!(:taric_update2) { create :taric_update, :pending, issue_date: Date.today }

    it 'returns rendered records' do
      get :index, format: :json

      expect(response.body).to match_json_expression pattern
      expect(response.body).to match_json_expression pagination_pattern
    end
  end

  context 'when records are not present' do
    it 'returns blank array' do
      get :index, format: :json

      expect(JSON.parse(response.body)["updates"]).to eq []
    end
  end
end

describe Api::V1::UpdatesController, "GET #latest" do
  render_views

  let(:pattern) {
    [{ update_type: String,
      state: String,
      filename: String}.ignore_extra_keys!].ignore_extra_values!
  }

  context 'when records are present' do
    let!(:chief_update) { create :chief_update, :applied }
    let!(:taric_update) { create :taric_update, :applied }

    it 'returns rendered records' do
      get :latest, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'when records are not present' do
    it 'returns blank array' do
      get :latest, format: :json

      expect(
        JSON.parse(response.body)
      ).to eq []
    end
  end
end
