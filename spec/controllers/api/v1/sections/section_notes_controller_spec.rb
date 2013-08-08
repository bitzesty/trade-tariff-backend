require 'spec_helper'

describe Api::V1::Sections::SectionNotesController, "GET #show" do
  render_views

  let(:pattern) {
    {
      id: Integer,
      section_id: Integer,
      content: String
    }
  }

  before { login_as_api_user }

  context 'when section note is present' do
    let(:section) { create :section, :with_note }

    it 'returns rendered record' do
      get :show, section_id: section.id, format: :json

      response.body.should match_json_expression pattern
    end
  end

  context 'when section note is not present' do
    let(:section) { create :section }

    it 'returns not found if record was not found' do
      get :show, section_id: section.id, format: :json

      expect(response.status).to eq 404
    end
  end
end

describe Api::V1::Sections::SectionNotesController, "POST to #create" do
  pending
end

describe Api::V1::Sections::SectionNotesController, "PUT to #update" do
  pending
end

describe Api::V1::Sections::SectionNotesController, "DELETE to #destroy" do
  pending
end
