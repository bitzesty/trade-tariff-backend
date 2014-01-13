require 'spec_helper'

describe Api::V1::RollbacksController, "POST to #create", sidekiq: :inline do
  render_views

  before { login_as_api_user }

  let(:rollback_date) { Date.today.ago(1.month).to_date }
  let(:record)        {
    create :measure, operation_date: Date.yesterday.to_date
  }

  context 'when rollback is valid' do
    before { record }

    it 'responds with success + redirect' do
      post :create, rollback: { date: rollback_date }

      expect(response.status).to eq 201
      expect(response.location).to eq api_rollbacks_url
    end

    it 'performs a rollback' do
      Sidekiq::Testing.inline! do
        expect {
          post :create, rollback: { date: rollback_date }
        }.to change { Measure.count }.from(1).to(0)
      end
    end
  end

  context 'when rollback is not valid' do
    let(:response_pattern) {
      {
        errors: Hash
      }.ignore_extra_keys!
    }

    it 'returns errors for rollback' do
      post :create, rollback: { date: '', redownload: '' }

      expect(response.status).to eq 422
      expect(response.body).to match_json_expression response_pattern
    end
  end
end


describe Api::V1::RollbacksController, "GET to #index", sidekiq: :fake do
  render_views

  before {
    login_as_api_user
  }

  let(:response_pattern) {
    [
      {
        jid: String,
        enqueued_at: String,
        rollback_to: String,
        redownload: false
      }.ignore_extra_keys!
    ].ignore_extra_values!
  }

  it 'returns scheduled rollbacks' do
    get :index, format: :json

    expect(response.status).to eq 200
    expect(response.body).to match_json_expression response_pattern
  end
end
