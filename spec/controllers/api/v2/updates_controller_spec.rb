require 'rails_helper'

describe Api::V2::UpdatesController, "GET #index" do
  render_views

  let(:pattern) {
    {
      data: [
        {
          id: String,
          type: 'tariff_update',
          attributes: {
            update_type: "TariffSynchronizer::TaricUpdate",
            state: String,
            filename: String,
            created_at: String
          }.ignore_extra_keys!
        }.ignore_extra_keys!,
        {
          id: String,
          type: 'tariff_update',
          attributes: {
            update_type: "TariffSynchronizer::TaricUpdate",
            state: String,
            filename: String,
            created_at: String
          }.ignore_extra_keys!
        }.ignore_extra_keys!
      ],
      meta: {
        pagination: {
          page: Integer,
          per_page: Integer,
          total_count: Integer
        }
      }
    }
  }

  context 'when records are present' do
    let!(:taric_update1) { create :taric_update, :applied, issue_date: Date.yesterday }
    let!(:taric_update2) { create :taric_update, :pending, issue_date: Date.current }

    it 'returns rendered records' do
      get :index, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'when records are not present' do
    it 'returns blank array' do
      get :index, format: :json

      expect(JSON.parse(response.body)['data']).to eq []
    end
  end
end

describe Api::V2::UpdatesController, "GET #latest" do
  render_views

  let(:pattern) do
    {
      data: [
        {
          id: String,
            type: 'tariff_update',
            attributes: {
            update_type: "TariffSynchronizer::TaricUpdate",
            state: String,
            filename: String,
            created_at: String
          }.ignore_extra_keys!
        }.ignore_extra_keys!
      ].ignore_extra_values!
    }
  end

  context 'when records are present' do
    it 'returns rendered records' do
      create :chief_update, :applied
      create :taric_update, :applied

      get :latest, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end

  context 'when records are not present' do
    it 'returns blank array' do
      get :latest, format: :json

      expect(
        JSON.parse(response.body)['data']
      ).to eq []
    end
  end
end
