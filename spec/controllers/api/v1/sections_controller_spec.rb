require 'spec_helper'

describe Api::V1::SectionsController, "GET #show" do
  render_views

  let(:section) { create :section }

  let(:pattern) {
    {
      position: Integer,
      title: String,
      numeral: String
    }.ignore_extra_keys!
  }

  context 'when record is present' do
    it 'returns rendered record' do
      get :show, id: section.position, format: :json

      response.body.should match_json_expression pattern
    end
  end

  context 'when record is not present' do
    it 'returns not found if record was not found' do
      expect { get :show, id: "5", format: :json }.to raise_error Sequel::RecordNotFound
    end
  end
end

describe Api::V1::SectionsController, "GET #index" do
  render_views

  let!(:section1) { create :section }
  let!(:section2) { create :section }

  let(:pattern) {
    [
      {position: Integer, title: String, numeral: String}.ignore_extra_keys!,
      {position: Integer, title: String, numeral: String}.ignore_extra_keys!
    ]
  }

  it 'returns rendered records' do
    get :index, format: :json

    response.body.should match_json_expression pattern
  end
end
