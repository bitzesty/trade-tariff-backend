require 'rails_helper'

describe Api::V1::RollbacksController, "POST to #create" do
  render_views

  before { login_as_api_user }

  let(:rollback_attributes) { attributes_for :rollback }
  let(:record)        {
    create :measure, operation_date: Date.yesterday.to_date
  }

  context 'when rollback is valid' do
    before { record }

    it 'responds with success + redirect' do
      post :create, rollback: rollback_attributes

      expect(response.status).to eq 201
      expect(response.location).to eq api_rollbacks_url
    end

    it 'performs a rollback' do
      Sidekiq::Testing.inline! do
        expect {
          create(:rollback, date: Date.today.ago(1.month).to_date)
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
      post :create, rollback: { date: '', keep: '' }

      expect(response.status).to eq 422
      expect(response.body).to match_json_expression response_pattern
    end
  end
end

describe Api::V1::RollbacksController, "GET to #index" do
  render_views

  before {
    login_as_api_user
  }

  let!(:rollback) { create :rollback }

  let(:response_pattern) {
    { rollbacks:
      [
        {
          id: rollback.id,
          user_id: rollback.user_id,
          reason: rollback.reason,
          enqueued_at: wildcard_matcher,
          date: rollback.date.to_s,
          keep: rollback.keep
        }.ignore_extra_keys!
      ].ignore_extra_values!
    }.ignore_extra_keys!
  }

  it 'returns scheduled rollbacks' do
    get :index, format: :json

    expect(response.status).to eq 200
    expect(response.body).to match_json_expression response_pattern
    expect(response.body).to match_json_expression pagination_pattern
  end
end
