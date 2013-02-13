require 'spec_helper'

describe Api::V1::UpdatesController, "GET #index" do
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
      get :index, format: :json

      response.body.should match_json_expression pattern
    end
  end

  context 'when records are not present' do
    it 'returns blank array' do
      get :index, format: :json

      JSON.parse(response.body).should eq []
    end
  end
end
